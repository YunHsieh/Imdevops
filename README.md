# imbee_hw

I used tools as the below:
- terraform for aws
- python ormar model
- firebase

System recommand MacOS
## Prerequisite
- [awscliv2](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
- [npm](https://nodejs.org/en/download/)
- [terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)

Intsall if you don't have yet
```bash
npm install -g serverless
```

When you first time to start it.
```bash
# Give sh run permission if you needed
chmod 755 ./setup.sh ./src/devops/build-ecr.sh ./src/devops/merge.sh

./setup.sh
```

How to test
```bash
1. Go to aws console
2. Search SQS
3. Entry the sqs service
4. Find "imbee-notification-fcm.fifo" sqs and click it
5. Click "Send and receive messages"
6. send a message as below sample:
# ---
# mock firebase success
{
   "status": "success"
}
# mock firebase timeout error
{
   "status": "timeout"
}
# mock firebase excced error
{
   "status": "excced"
}
# ---

7. Go to the SQS find the 'imbee-notification-done-fcm.fifo' check the message

```

## Cloud Architecture Diagram

![image](https://user-images.githubusercontent.com/52973591/208701218-ac726d98-2f69-4028-ba4a-9514c7b59d74.png)

