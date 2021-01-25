# KPMG "mind the corona" Modelling Boilerplate

본 폴더는 원활한 모델 배포를 위해 개발 된 템플릿 입니다. 아래 사용 방법을 참조하여 개발해주시기 바랍니다.

## Overall

### 구조
``` shell
├── conf
│   ├── requirements.txt (optional)
│   └── config.yml
├── deploy.sh
├── Dockerfile
├── readme.md
├── saved_models
└── src
    ├── model.py
    └── test.py
```
### I/O 처리 방식
* 모델링 관련 I/O는 모두 json 형태의 messaging으로 진행 됩니다
* task와 무관하게 input 메시지의 json형태는 아래와 같습니다. ()
* 내용은 text의 경우 string 형태로, numerical data (video, audio)의 경우 list (of lists of lists ...)로 전달 받습니다.
``` 
{"input": some_input}

# example text input
{"input": "안녕 세계"}

# example numerical inputs
{"input": [[79, 80, 100, ...],...]}
```
* output 메시지는 task에 따라 다를 것으로 예상 됩니다. Inference를 거친 모델 결과 값을 json형태로 잘 정리하여 아래와 같은 json 메시지 형태로 전달합니다.
* output 메세지 형태가 정리되면 모델러들은 front-end개발자에게 메시지 형태를 알려줍니다.
```
{"output": some_output}

# example of unsophisticated output
{"output": [0.78912, 0.61311, ...]}

# example of sophisticated output
{"output": 
    "model_results": [0.71321, 0.1231, ...],
    "word_frequency": 
        {"우울하다": 10,
         "괜찮아": 5,
         "코로나": 21, ...}
}
```
### 개발
#### 모델링
* 모델 초기화는 "src > model.py > class model > def \_\_init\_\_" 에서 초기화/로딩을 반드시 해야 합니다.
* 모델은 모델 전체를 save해서 saved_models 폴더에 저장하는 것을 권장합니다. 특수한 경우, 하나 이상의 모델을 로딩해야할 경우는 필요에 따라 잘 초기화 해주시면 됩니다.
* 모델 inference는 "src > model.py > class model > def inference" 에서 진행 됩니다. 이 부분을 모델의 특성에 따라 개발해주시면 됩니다.
* 모델의 복잡도/결과값에 상관없이 항상 input은 위 I/O에서 정의된 형태로 전달되니 이에 따라 개발 진행해주시면 됩니다. 여기서 약속한 사항들을 아래 unit test 그리고 모델 배포에서 그대로 사용하기 때문에 꼭 지켜주시기 바랍니다.
* 특수한 경우에 따라 다른 구조가 필요한 경우는 개발자들과 논의 후 수정하도록 합니다.
#### 기타
* 주어진 파일들 중 "modeller"로 표시 되어 있는 부분을 채워넣으시면 됩니다.
* 그 외 추가로 필요한 파일들은 dependency 고려 없이 자유롭게 추가하시면서 개발 진행하시면 됩니다.

## Unittest
* 배포전 unittest를 진행하여 코드에 문제가 없는지 확인해주시기 바랍니다.
* unit test를 진행하기 위해 conf > config.yml > test_settings 에서 input 타입과 dimension을 정의해주셔야 합니다.
``` shell
# unittest code
python ./src/test.py 
```

## Deployment
* docker를 통한 배포는 아래 코드로 진행합니다. 배포전에 unit test를 자동으로 한 번 진행하니 혹시 실패한다면 배포를 중지 하고 디버깅을 진행해주시기 바랍니다.
* image name은 필수로 정의하여야 하고, container name은 필수는 아니지만 정의하시는 것을 권장합니다.
``` shell
# docker deployment code
bash deploy.sh [image_name] [container_name]

# example of docker deployment
bash deploy.sh vid_docker_img dockerize_video
```
* 재배포시 Dockerfile에서 첫번째 줄이 "FROM python:x.x.x"로 되어 있으면 이 줄만 삭제 하고 다시 배포해주세요 (권장사항)

## 총 과정 요약
(원하는 환경에서 모델 실험/개발)
1. 저장된 모델 weight를 saved_models폴더에 저장
2. 배포용 모델 개발 
    * "src > model.py > class model > def \_\_init\_\_" 에서 모델 초기화
    * "src > model.py > class model > def inference" 에서 모델 inference 개발
3. unit test를 위한 설정 (conf > config.yml > test_settings)
4. unit test 진행
5. 배포