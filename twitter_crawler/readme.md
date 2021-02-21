# Crawling code

#### Twitter Crawling

- Input
  - Twitter nickname as string
   - ex) "@TheBlueHouseKR"

- Output
   - json file

     ~~~{
       POST ID -> int: {
     "time" : MOMENT WHEN POST IS CREATED -> isoformat(yyyy-mm-ddThh:mm:ss)
     "text" : TEXT OF TWEET -> str
     "media" : LINK OF PHOTO OR SHORT VIDEO IN TWEET -> str
       },
     ~~~

   - ex)

     ```
     {
     	"1359771826054811651": {
     		"created_at": "2021-02-11T07:50:41",
     		"text": "문재인 대통령은 설 연휴 첫날인 오늘, 국내·외 각지에서 지내는 국민들과 영상 통화로 직접 소통하며 코로나19로 어려운 시기를 견뎌낸 데 대한 위로와 감사의 마음을 전했습니다. 오늘 영상 통화를 진행한 여덟 분은 '용기와 도전'이라는 메시지를 담고 있는 분들입니다. \n\n",
     		"image": "http://pbs.twimg.com/media/Et7hIQfUUAII42K.jpg"
     	},
     	"1359476520817811470": {
     		"created_at": "2021-02-10T12:17:15",
     		"text": "\"다시 문을 열었습니다\"\n설을 앞두고 문재인 대통령은 김정숙 여사와 함께 인천 소래포구 전통어시장을 찾아 상인들을 격려했습니다. 소래포구 어시장은 2017년 화재로 소실되어 지난해 12월 다시 문을 열었습니다. 새로운 모습으로 손님을 기다리고 있는 소래포구 어시장, KTV에서 전합니다. ",
     		"image": "http://pbs.twimg.com/media/Et7hIQfUUAII42K.jpg"
     	}, ...
     }
     ```

  


#### Facebook Crawling

#### Instagram Crawling
