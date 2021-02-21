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
{
'output_0.20833333333333331': 
  {'results': 
    {'emotions': ['Neutral', 'Neutral', 'Neutral', 'Neutral', 'Neutral', 'Neutral', 'Neutral', 'Neutral', 'Sad', 'Neutral'], 
     'affects': array([[-0.20084167,  0.44597203],
                       [-0.10087757,  0.55338764],
                       [-0.26037872,  0.42633885],
                       [-0.14293277,  0.49539962],
                       [-0.18266904,  0.5277382 ],
                       [-0.21879548,  0.50944525],
                       [ 0.02451667,  0.65122557],
                       [-0.19981277,  0.44359812],
                       [-0.06656936,  0.50897276],
                       [-0.14981785,  0.50689757]], dtype=float32)}, 
   'method': 'FER'}, 
   
'output_0.4583333333333333': 
  {'results': 
    {'emotions': ['Sad', 'Sad', 'Sad', 'Sad', 'Sad', 'Sad', 'Sad', 'Sad', 'Sad', 'Sad'], 
     'affects': array([[-0.20377053,  0.45312032],
                       [-0.089092  ,  0.5558793 ],
                       [-0.22493865,  0.43753183],
                       [-0.13619623,  0.50202024],
                       [-0.18757848,  0.5283282 ],
                       [-0.22866139,  0.5036394 ],
                       [ 0.03945579,  0.6396925 ],
                       [-0.19511369,  0.44532076],
                       [-0.06337182,  0.50961787],
                       [-0.14325188,  0.5083501 ]], dtype=float32)}, 
   'method': 'FER'}
}
...]

```

* Note that each frame is saved locally
