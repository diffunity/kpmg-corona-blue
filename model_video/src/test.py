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
        
        r["db_directory"] = "../"
        r["video_path"] = "../test_ver2.mp4"
        r["user_image"] = "../known_image.jpg"

        output = self.model.inference(r)

        print("Unittest output: ", output)


if __name__ == '__main__':
    unittest.main()
