from PIL import Image
import stylecloud
import random
import string
import boto3


def generate_wordcloud(word_counts):
    IMG_PATH = "img.png"
    file_name =''.join(random.choice(string.ascii_lowercase + string.ascii_uppercase + string.digits) for _ in range(10)) + '.png'
    stylecloud.gen_stylecloud(text=word_counts,
                              icon_name="fas fa-cloud",
                              palette="colorbrewer.diverging.Spectral_11",
                              output_name=IMG_PATH)

    img = Image.open(IMG_PATH)
    area = (0, 60, 512, 440)
    cropped_img = img.crop(area)
    cropped_img.save(file_name)
    return file_name


def save_into_s3(name):
    s3 = boto3.client("s3")
    bucket = 'kpmg-ybigta-image'
    key = f'wordcloud/{name}'
    s3.upload_file(name, bucket, key)

    img_url = f"https://kpmg-ybigta-image.s3.ap-northeast-2.amazonaws.com/wordcloud/{name}"

    return img_url

