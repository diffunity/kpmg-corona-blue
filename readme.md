# caramel: Mental Health Assistant

> For 2021 KPMG Ideathon

<div>
    <p align center>
		<img width = "300" src = "https://user-images.githubusercontent.com/61009073/108615472-e184aa00-7447-11eb-8ca2-228747e4a582.png">
    </p>
</div>

* [Introduction](https://github.com/diffunity/kpmg-corona-blue#Introduction)

* [Overview](https://github.com/diffunity/kpmg-corona-blue#Overview)

  * Overall display
  * Main tab
  * Text tab
  * Voice tab
  * Visual tab

* [Branch Structure](https://github.com/diffunity/kpmg-corona-blue#Branch-Structure)

* [Further Steps](https://github.com/diffunity/kpmg-corona-blue#Further-Steps)

  

# Introduction

Caramel is an application that lets you know your mental status. It can analyze your emotions in your phone call, SNS texts and picture, etc. 



# Overview 

- Overall display

<div>
    <img width="100", src="https://user-images.githubusercontent.com/61009073/108615739-77213900-744a-11eb-9993-b39de8968c14.png">
    <img width="100", src="https://user-images.githubusercontent.com/61009073/108615871-ae441a00-744b-11eb-9ea2-7ca71d5b9f75.png">
    <img width="100", src="https://user-images.githubusercontent.com/61009073/108615872-af754700-744b-11eb-8cc3-809ae1a21075.png">
    <img width="100", src="https://user-images.githubusercontent.com/61009073/108615873-b2703780-744b-11eb-8311-d46366b0a304.png">
</div>

- Main tab

  - Update analyzed data with an update button
  - Display total happiness score as 'Caramel Score'
  - Redirect user to each tab, which provide score about specific sense

- Text tab

  - Provide user's emotions in SNS posts

- Voice tab

  - Provide user's emotions in phone call
  - Divided into two sections: Tone & Content
    - Tone: Analyze user's tone and pitch, accents and determine user's emotion only with them. Do not use contents of conversation at all
    - Content: Analyze user's conversational contents during the phone call. Use Google STT API to make speech data to text

- Visual tab

  - Analyze user's photos and videos with vision model
  - Automatically detect face in the photo
    - In case of face exists in photo, the model use facial expression recognition model
    - In case of face do not exists in photo, the model user sentimental image detection model
  - Divided into two sections: Photo & Video

  

# Branch Structure 

* Branch structure

```shell
├── main (empty)
└── dev
    ├── model
    │   ├── nlp
    │   ├── vision
    │   └── audio
    ├── backend
    └── frontend
```



# Further Steps 

