from PIL import Image
import stylecloud

    def main(self, word_counts):
        IMG_PATH = "img.png"
        stylecloud.gen_stylecloud(text=word_counts, 
                                  icon_name="fas fa-cloud",
                                  palette="colorbrewer.diverging.Spectral_11", 
                                  output_name=IMG_PATH)

        img = Image.open(IMG_PATH)
        area = (0, 60, 512, 440)
        cropped_img = img.crop(area)
        
        return cropped_img