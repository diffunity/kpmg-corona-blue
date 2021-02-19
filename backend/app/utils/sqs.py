import boto3
import time
import json
import logging
from typing import Dict, Optional
from botocore.exceptions import ClientError

from config import CONFIG

client = boto3.client("sqs", region_name="ap-northeast-2")
logging.basicConfig(level=logging.INFO, format='%(asctime)s %(levelname)s : %(message)s',
                    datefmt="%Y-%m-%d %H:%M:%S")
logger = logging.getLogger(__name__)


class SQS:

    @classmethod
    def send_message(cls, sqs_url: str, message_body: Dict) -> int:
        response = client.send_message(QueueUrl=sqs_url, MessageBody=json.dumps(message_body))
        # {'MD5OfMessageBody': 'f4c60d9169cf09c73341853cf04c9392',
        #  'MessageId': '74fd9bec-7942-46ed-9a55-c06d1dac5288',
        #  'ResponseMetadata': {'RequestId': 'e78a8b3e-5fef-5439-a9b6-d3962df5b3a1',
        #                       'HTTPStatusCode': 200,
        #                       'HTTPHeaders': {'x-amzn-requestid': 'e78a8b3e-5fef-5439-a9b6-d3962df5b3a1',
        #                                       'date': 'Thu, 18 Feb 2021 13:47:06 GMT',
        #                                       'content-type': 'text/xml',
        #                                       'content-length': '378'},
        #                       'RetryAttempts': 0}}
        return response["ResponseMetadata"]["HTTPStatusCode"]

    @classmethod
    def receive_message(cls, sqs_url: str) -> Optional[Dict]:
        response = client.receive_message(QueueUrl=sqs_url, MaxNumberOfMessages=1, WaitTimeSeconds=20)
        # no message
        # {'ResponseMetadata': {'RequestId': 'b3ae256f-45f4-5c03-8c32-7dc733716d9e',
        #                       'HTTPStatusCode': 200,
        #                       'HTTPHeaders': {'x-amzn-requestid': 'b3ae256f-45f4-5c03-8c32-7dc733716d9e',
        #                                       'date': 'Thu, 18 Feb 2021 14:06:07 GMT',
        #                                       'content-type': 'text/xml',
        #                                       'content-length': '240'},
        #                       'RetryAttempts': 0}}
        # message exists
        # {'Messages': [{'MessageId': '74fd9bec-7942-46ed-9a55-c06d1dac5288',
        #                 'ReceiptHandle': 'AQEBb9S/N/NCEhYtmJOh2JM7OM1+A2aSqrWz460AuCgW4e2hzTYqFO5TBCqKM1E6MOgyCS6cwKcOWMC1lvW95GBlUTlmDKGNwyszNgOdxUI7qZWAQrN4zsi0rnywQo4/SAPFezIVdnzH3T8Uyc9fSo+5M0Z5FS5Oeiput5DPy/6r2nrm8Joh0CxW393TiKZogI1uPtNcRz9HDLt1i1Kokk3DgnqlbMZnXlEFoV31tJr3zi8jbhUOHshQbRGphafOGzeUipm3HYXvgOXUl/21hR99Wo2Rw5UZTpGFrf0G9VeIb7LHaXCtaEJY1/mq2d5zj4+6sPh/9JYOK1hM0mEl1E4rmnhkzVKcUX7EWWt93b4mDMLsZuOixtW4eSlfbaLFtHZNffu1b7vFf75sV5A+TfbZ2A==',
        #                 'MD5OfBody': 'f4c60d9169cf09c73341853cf04c9392',
        #                 'Body': '{"request_id": 1, "create_date_time": "2021-02-18 22:33:48"}'}],
        #   'ResponseMetadata': {'RequestId': '87ffb197-19dc-5757-89de-e93f6bc120cf',
        #                        'HTTPStatusCode': 200,
        #                        'HTTPHeaders': {'x-amzn-requestid': '87ffb197-19dc-5757-89de-e93f6bc120cf',
        #
        # 'date': 'Thu, 18 Feb 2021 13:47:09 GMT',
        # 'content-type': 'text/xml',
        # 'content-length': '941'},
        # 'RetryAttempts': 0}}
        if "Messages" in response:
            sqs_message = response["Messages"][0]
            message_body = json.loads(sqs_message["Body"])
            logger.info(f"message received: {sqs_message}")

            return {"ReceiptHandle": sqs_message["ReceiptHandle"], "Body": message_body}

        else:
            logger.error(f"No message to receive.")
            return None

    @classmethod
    def delete_message(cls, sqs_url, ReceiptHandle):
        response = client.delete_message(QueueUrl=sqs_url, ReceiptHandle=ReceiptHandle)
        # {'ResponseMetadata': {'RequestId': '35f7be1d-5bd8-5784-8869-e6b52db3bbc1',
        #                       'HTTPStatusCode': 200,
        #                       'HTTPHeaders': {'x-amzn-requestid': '35f7be1d-5bd8-5784-8869-e6b52db3bbc1',
        #                                       'date': 'Thu, 18 Feb 2021 14:05:31 GMT',
        #                                       'content-type': 'text/xml',
        #                                       'content-length': '215'},
        #                       'RetryAttempts': 0}}
        logger.info(f"message {ReceiptHandle} deleted")

        return response["HTTPStatusCode"]


