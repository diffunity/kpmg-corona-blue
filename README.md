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
    	{'contents': 
            {'input_image': <some-array-of-image>, 
            'face_coordinates': (357, 726, 911, 171), 
            'face_image': <some-array-of-image>, 
            'list_emotion': ['Sad', 'Sad', 'Neutral', 'Sad', 'Sad', 'Sad', 'Neutral', 'Neutral', 'Neutral', 'Sad'], 
            'list_affect': array([[-0.21209078,  0.43655968],...])}, 
        'method': 'FER'}}
```

**pending fixes**: select only necessary features for FER result contents