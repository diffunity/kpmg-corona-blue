<<<<<<< HEAD
# Frontend - iOS App
## Caramel
![gif](https://media.giphy.com/media/A63Mo8DzOgMJTsPKmv/giphy.gif)
![gif](https://media.giphy.com/media/nJ8RMHSnnzu7rlWblb/giphy.gif)
![gif](https://media.giphy.com/media/5JrIM35lZGCJy22ORt/giphy.gif)

## Requirements
- Swift 5
- Xcode
- Cocoapods

## Run project
### Installation
- Install CocoaPods
  ```
  $ sudo gem install cocoapods
  ```
- Navigate to the directory where file MHCare.xcworkspace is located and enter command
  ```
  pod install
  ```

### Build and Run
- Open file **MHCare.xcworkspace**
- Go to Signing & Capabilities tab and set your own Team / Bundle Identifier
  <img src="src/signings.png" width="70%" height="70%">

- Set the device to a physical iOS device (Some functions might not work when running on a simulator)
  <img src="src/device.png" width="70%" height="70%">
- Run!!
=======
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
{'output': {'Depressed': 6, 'Non-depressed': 76}, 'text': {'count': 82, 'text': "chocolate cookies would be fine with me you probably want your ice cream I better write down all these things otherwise I will forget them by the time I get to the market right as far as meat mom wants some beef and some chicken  just any kind of beef I forgot to ask Mom about that but I think it would be...
```
>>>>>>> audio
