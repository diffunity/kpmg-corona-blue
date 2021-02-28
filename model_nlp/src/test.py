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
#            r = {"input": ["Hello worlds", "Hi worlds"]}
            r = {"input": "Hello worlds. Hi Worlds"}
        else:
            dim = self.test_configs["input_dimension"]
            r = {"input": np.ndarray(dim).tolist()}

        output = self.model.inference(r)

        print("Unittest output: ", output)

    def test_case2(self):
        if self.test_configs["input_type"] == "text":
#            r = {"input": ["Hello again worlds", "Hi again worlds"]}
            r = {"input": "Hello again worlds. Hi again Worlds"}
        else:
            dim = self.test_configs["input_dimension"]
            r = {"input": np.ndarray(dim).tolist()}

        output = self.model.inference(r)

        print("Unittest output: ", output)


if __name__ == '__main__':
    unittest.main()
