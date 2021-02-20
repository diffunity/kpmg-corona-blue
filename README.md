# Video model

## Overall process

* conduct face detection on each frame of the video

* if face is detected, compare with the submitted user's image. If it matches, conduct facial emotion recognition analysis

* if no face is detected, return no results

## I/O protocols

* video has to be in .mp4 format

### Input

``` python
message = {"db_directory" = <directory-of-saved-videos>,
           "video_path" = <video-filename>,
           "user_image" = <user-image-for-face-matching>}

# example
message = {"db_directory" = "./"
           "file_list" = "./test.mp4",
           "user_image" = "./known_image.jpg"}
```

### Output

* requires decision

``` python
# current output format
result = [

{'input_image': <some-array-of-image>, 
 'face_coordinates': (357, 726, 911, 171), 
 'face_image': <some-array-of-image>, 
 'list_emotion': ['Sad', 'Sad', 'Neutral', 'Sad', 'Sad', 'Sad', 'Neutral', 'Neutral', 'Neutral', 'Sad'], 
 'list_affect': array([[-0.21209078,  0.43655968],...])},

{'input_image': <some-array-of-image>, 
 'face_coordinates': (357, 726, 911, 171), 
 'face_image': <some-array-of-image>, 
 'list_emotion': ['Sad', 'Sad', 'Neutral', 'Sad', 'Sad', 'Sad', 'Neutral', 'Neutral', 'Neutral', 'Sad'], 
 'list_affect': array([[-0.21209078,  0.43655968],...])},

...]

```

**pending fixes**: what values to pass onto the app?

