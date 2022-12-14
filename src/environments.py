import os
DATABASE_URL = os.getenv('DATABASE_URI', 'db')
DATABASE_USERNAME = os.getenv('DATABASE_USERNAME', 'dev')
DATABASE_PASSWORD = os.getenv('DATABASE_PASSWORD', 'dev')
DATABASE_NAME = os.getenv('DATABASE_NAME', 'dev')
DATABASE_URI = os.getenv('DATABASE_URI', f'mysql://{DATABASE_USERNAME}:{DATABASE_PASSWORD}@{DATABASE_URL}/{DATABASE_NAME}')

STAGE = os.getenv('STAGE', 'dev')
REGION = os.getenv('region', 'ap-northeast-1')

SQS_NOTIFICATION_DONE_URL = os.getenv('SQS_NOTIFICATION_DONE_URL', 'imbee-notification-done-fcm.fifo')
