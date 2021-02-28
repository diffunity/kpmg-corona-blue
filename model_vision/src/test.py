import sys
import yaml
import unittest
import numpy as np
from model import model

class Test(unittest.TestCase):
    def setUp(self):

        configs = yaml.load(open("./conf/config.yml").read(), Loader=yaml.Loader)
        self.test_configs = configs["unittest_settings"]

        self.model = model()

    def test_case1(self):
        if self.test_configs["input_type"] == "text":
            r = {"input": "안녕 세계"}
        else:
            dim = self.test_configs["input_dimension"]
            r = {"input": np.ndarray(dim).tolist()}

        # mock message from backend
#        r["db_directory"] = "../TestData"
#        r["file_list"] = "../image_list.txt"
#        r["user_image"] = "../known_image.jpg"
        # r["input"] = "https://raw.githubusercontent.com/diffunity/kpmg-corona-blue/vision/vision_model/images/image_UML.jpg"
        r["input"] = "./self_6.jpg"

        output = self.model.inference(r)

        print("Unittest output: ", output)


if __name__ == '__main__':
    unittest.main()
