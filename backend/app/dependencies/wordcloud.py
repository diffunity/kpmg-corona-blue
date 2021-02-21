from PIL import Image
import stylecloud
import random
import string
import boto3


def generate_wordcloud(word_counts, TAB):
    # TAB = "voice"
    # TAB = "visual"
    IMG_PATH = "img.png"

    if TAB == "text":
        palette = ["#eb51be", "#fc9be2", "#ffc4dd"]
    elif TAB == "voice":
        palette = ["#4238f2", "#608afa", "83b6ff"]
    elif TAB == "visual":
        palette = ["#8672f4", "a090fc", "#c6c0ff"]

    file_name = ''.join(
        random.choice(string.ascii_lowercase + string.ascii_uppercase + string.digits) for _ in range(10)) + '.png'
    stylecloud.gen_stylecloud(text=word_counts,
                              icon_name="fas fa-cloud",
                              colors=palette,
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


