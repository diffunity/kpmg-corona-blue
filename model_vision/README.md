# Vision model

## Overall process

* conduct face detection on the submitted image

* if face is detected, compare with the submitted user's image. If it matches, conduct facial emotion recognition analysis

* if no face is detected, conduct Visual Sentiment Analysis

## I/O protocols

### Input

``` python
message = {"db_directory" = <directory-of-saved-images>,
           "file_list" = <filename-containing-list-of-images-to-analyze>,
           "user_image" = <user-image-for-face-matching>}

# example
message = {"db_directory" = "./TestData"
           "file_list" = "./image_list.txt",
           "user_image" = "./known_image.jpg"}
```


**pending fixes**: use Twitter API to extract images directly, and not save them on the local machine

### Output

``` python
result = {"output_<i>":
              {"contents": <analysis-result>,
               "method": ["VSA"|"FER"]}}

# example
result = {
    'output_0': 
        {'contents': [[0.31435611844062805, 0.2580610513687134, 0.42758283019065857]], 
        'method': 'VSA'}, 

    'output_1': 
    	{'results': 
        {'emotions': ['Sad', 'Sad', 'Sad', 'Sad', 'Sad', 'Sad', 'Sad', 'Sad', 'Sad', 'Sad'], 
          'affects': array([[-0.20710072,  0.41372514],
                            [-0.2923277 ,  0.5747444 ],
                            [-0.27150244,  0.42269933],
                            [-0.23067674,  0.56988555],
                            [-0.41185334,  0.48492265],
                            [-0.3649952 ,  0.47604904],
                            [ 0.02373752,  0.67886865],
                            [-0.31549323,  0.43870547],
                            [-0.06729096,  0.5077689 ],
                            [-0.23750032,  0.50748545]], dtype=float32)}, 
          'method': 'FER'}}
```

* Note that FER saves the facial image

## Pretrained Models

* Pretrained models can be downloaded by running the below bash file. This file is provided in [github](https://github.com/fabiocarrara/visual-sentiment-analysis)

```shell
bash download_models.sh
```
