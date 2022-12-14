import asyncio
import requests
import json
import boto3
from models import Notification, with_connect
from environments import REGION, SQS_NOTIFICATION_DONE_URL
from botocore.exceptions import ClientError

sqs = boto3.client('sqs', region_name=REGION)

headers = {
    'Content-Type': 'application/json',
    'Authorization': 'key=AIzaSyZ-1u0GBYzPu7Udno5aA',
}


def success_response():
    '''
    Mock firebase response
    '''
    payload = { 
        "data": {
            "hello": "This is a Firebase Cloud Messaging Device Group Message!",
    },
        "to" : "bk3RNwTe3H0:CI2k_HHwgIpoDKCIZvvDMExUdFQ3P1..."
    }
    rep = requests.Response()
    rep.headers = headers
    rep.status_code = 200
    rep._content = json.dumps(payload).encode('utf-8')
    return rep


def timeout_response():
    payload = {
        "error": "Timeout"
    }
    rep = requests.Response()
    rep.headers = headers
    rep.status_code = 400
    rep._content = json.dumps(payload).encode('utf-8')
    return rep


def message_exceed_response():
    payload = {
        "error": "TopicsMessageRateExceeded"
    }
    rep = requests.Response()
    rep.headers = headers
    rep.status_code = 400
    rep._content = json.dumps(payload).encode('utf-8')
    return rep


async def save_message(rep: requests.Response):
    '''
    write response into db
    '''
    if rep.status_code != 200:
        raise Exception('Get the bad status code')
    instance = Notification(
        name='notification',
        state=rep.status_code,
        responsed_text=rep.content,
    )
    await instance.save()
    return True


def mock_firebase(event, context):
    mock_response = {
        'success': success_response,
        'timeout': timeout_response,
        'excced': message_exceed_response
    }

    asyncio.run(
        with_connect(
            save_message, 
            {
                'rep': mock_response.get(event.get('status', ''), success_response)()
            }
        )
    )
    try:
        response = sqs.send_message(
            QueueUrl=SQS_NOTIFICATION_DONE_URL,
            MessageBody=json.dumps({
                'status_text': 'success',
            }),
        )
    except ClientError as e:
        print("Unexpected error: %s" % e)
    return {
        'message_id': response['MessageId']
    }

mock_firebase({'status': 'success'}, {})
