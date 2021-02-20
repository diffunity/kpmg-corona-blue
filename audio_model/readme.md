## Audio model
This model predicts whether your feeling is depressed or not through voice files.

### File Tree
``` shell
├── conf
│   ├── config.yml
│   ├── pipreqs_bugfix.py
│   └── requirements.txt
├── saved_models
│   └── saved_model.h5
├── src
│   ├── config.py
│   ├── model.py
│   ├── preprocess.py
│   └── test.py
├── deploy.sh
├── Dockerfile
├── readme.md
├── sample.txt
└── voice_demo.ipynb
```

### Model I/O
Input: Audio file encoded in base64

``` shell
# Format
{"input": encoded string}

# Example
{"input": b'UklGRpQ2kwBXQVZFZm10IBAAAAABAAEAgD4AAAB9AAACABAAZGF0YQ42kwBDAkEDOQTnBW0IEQo/Cj0KBwrUCLcGQwR/Al0BOAB9/6H/ZQBXARkCeQLPAu4CngLFAdwA5P/n/lP9bfvz+aD4XfYJ9Aby1O/e7JjpqefZ577oOeoT7lz0bvu7AegHBA7LEu4UaxSSEnkP9Qr0BW0Bn/2J+6b62/o//DL+2wBLAy4EtwQLBY8EPQOkAeQAVgGkAUoC+QNXBpMIqQlFCsMKTwqLCFgGZgS8Au0Alf9Q/6f/IgC9AJcBdALQArwCYQKqAaYAb/82/oz80PqU+Sb4AfY9...}
```

Output: Analyzed Emotions and Speech Recognition Text

``` shell
# Format
{'output': {'Depressed': Depressed_num, 'Non-depressed': Non-depressed_num}, 'text': {'count': text_num, 'text': STT results}

# Example 
{'output': {'Depressed': 6, 'Non-depressed': 76}, 'text': {'count': 84, 'text': "also we almost ran out of it next what do you want for snack some chocolate cookies would be fine with me you probably want your ice cream i better write down all these things otherwise i will forget them by the time i get to the market... 
```
