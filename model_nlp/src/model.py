import json
import yaml
import torch
import numpy as np
import sys
import logging
import time

from transformers import BertTokenizer
from BertModel import BertForMultiLabelClassification
from multilabel_pipeline import MultiLabelPipeline

import nltk
from nltk.tokenize import sent_tokenize, WordPunctTokenizer
from nltk.stem import WordNetLemmatizer
from nltk.tag import pos_tag
from nltk import FreqDist
import re

from utils.config import CONFIG
from utils.db_connector import Connector
from utils.sqs import SQS

sqs = SQS()
conn = Connector()
logging.basicConfig(level=logging.INFO, format='%(asctime)s %(levelname)s : %(message)s',
                    datefmt="%Y-%m-%d %H:%M:%S")
logger = logging.getLogger(__name__)

    
class model:
    def __init__(self):
        
        nltk.download('wordnet')
        nltk.download('punkt')
        nltk.download('averaged_perceptron_tagger')

        self.tokenizer = BertTokenizer.from_pretrained(
            "monologg/bert-base-cased-goemotions-ekman")
        self.model = BertForMultiLabelClassification.from_pretrained(
            "monologg/bert-base-cased-goemotions-ekman")
        self.goemotions = MultiLabelPipeline(
            model=self.model,
            tokenizer=self.tokenizer,
            threshold=0.3
        )
        self.punct = WordPunctTokenizer()
        self.lm = WordNetLemmatizer()

    def inference(self, message: json):
        ## Expected input: {input: [whole text of the day until requested moment]}
        
        post = message["input"]
#        if type(posts) != list:
#            print("Input text must be a list")
#            sys.exit()

        GET_SENTENCE_COUNT = False
        try:
            sentence_count = message["sentence_count"]
            GET_SENTENCE_COUNT = True
        except: pass
            
        class_result = self.goemotions([post])[0]
#        for i in range(len(class_result)):
        if len(class_result['labels'])>1:
            best_score = max(class_result['scores'])
            best_index = class_result['scores'].index(best_score)
            best_label = class_result['labels'][best_index]

            class_result['labels'] = best_label
            class_result['scores'] = best_score
        else:
            class_result['labels'] = class_result['labels'][0]
            class_result['scores'] = class_result['scores'][0]
        
        punct = self.punct
        lm = self.lm
#        word_count_result = []
#        sentence_count_result = []
#        for post in posts:
#         print(post)
        words = punct.tokenize(post)
        words = [lm.lemmatize(w) for w in words]

        words = list(map(lambda x: re.sub('[^a-zA-Z]', '', x), words))
        words = list(filter(lambda x: len(x)>2, words))
        words = [t[0] for t in pos_tag(words) if t[1] not in ["IN", "CC", "TO", "PRP", "MD", "DT", "CD", "EX"]]
            #print(words)
        word_count_result = dict(FreqDist(words))        
#        word_count_result.append(dict(FreqDist(words)))
        if GET_SENTENCE_COUNT == False:
#            sentence_count_result.append(len(sent_tokenize(post)))
            sentence_count_result = len(sent_tokenize(post))
                
        return {"class": class_result, "word_count": word_count_result, "sentence_count": sentence_count_result}
    
        
    def deploy(self):

        ###########
        # sqs queue initialization (backend)
        #
        ###########

        look_at_queue = {"input": np.ndarray(
            self.config["unittest_settings"]["input_dimension"])}
        output = self.inference(look_at_queue)

        ###########
        # send back result to API by sqs (backend)
        #
        ###########

    def run(self):
        print("Model successfully deployed")
        while True:
            response = SQS.receive_message(CONFIG["SQS"]["request"]["text"])
            if response is not None:
                request_id = response['Body']
                query = conn.get_data_query("job_text", request_id)
                cur = conn.execute_query(query)

                try:
                    data_info = dict(cur.fetchall()[0])
                    data = data_info["content"]

                    message = dict()
                    message["input"] = data
                    nlp_result = model.inference(message)
                    logger.info(f"Executing {request_id} Done: {nlp_result}")

                except IndexError:
                    logger.error(f"No id {request_id} in job_text table")
                    continue

                sqs.delete_message(CONFIG["SQS"]["request"]["text"], response["ReceiptHandle"])
            else:
                time.sleep(3)


if __name__ == "__main__":
    model = model()
    model.run()

