from base64 import b64encode, b64decode
import librosa
import numpy as np
import soundfile as sf
from pydub import AudioSegment, effects
from pydub.silence import split_on_silence
import urllib3
import json
import base64
import ast
import os
import shutil


############################################################
# base64 decoding
############################################################
def encode_audio(audio):
    encoded_string = b64encode(open(audio, "rb").read())
    return encoded_string

def decode_audio(encoded_string):
    decoded_audio = b64decode(encoded_string)
    return decoded_audio

def save_audio(decoded_audio, filename):
    wav_file = open(filename, "wb")
    wav_file.write(decoded_audio)


############################################################
# audio segmentation
############################################################
def split_audio(record):
    sound_file = AudioSegment.from_wav(record)
    audio_chunks = split_on_silence(sound_file, min_silence_len=500, silence_thresh=-40)

    for i, chunk in enumerate(audio_chunks):
        out_file = "./chunk/{}.wav".format(str(i).zfill(4))
        chunk.export(out_file, format="wav")


############################################################
# volume normalize
############################################################
def normalize_audio(wav):
    rawsound = AudioSegment.from_file(wav, "wav")
    normalizedsound = effects.normalize(rawsound)
    normalizedsound.export(wav, format="wav")


############################################################
# feature extraction
############################################################
def extract_features(data):
    # ZCR
    result = np.array([])
    zcr = np.mean(librosa.feature.zero_crossing_rate(y=data).T, axis=0)
    result = np.hstack((result, zcr))  # stacking horizontally

    # Chroma_stft
    stft = np.abs(librosa.stft(data))
    chroma_stft = np.mean(librosa.feature.chroma_stft(S=stft, sr=16000).T, axis=0)
    result = np.hstack((result, chroma_stft))  # stacking horizontally

    # MFCC
    mfcc = np.mean(librosa.feature.mfcc(y=data, sr=16000).T, axis=0)
    result = np.hstack((result, mfcc))  # stacking horizontally

    # Root Mean Square Value
    rms = np.mean(librosa.feature.rms(y=data).T, axis=0)
    result = np.hstack((result, rms))  # stacking horizontally

    # MelSpectogram
    mel = np.mean(librosa.feature.melspectrogram(y=data, sr=16000).T, axis=0)
    result = np.hstack((result, mel))  # stacking horizontally

    return result

def get_features(path):
    data, sample_rate = librosa.load(path, duration=2.5, offset=0.6, sr=16000)
    res1 = extract_features(data)
    result = [np.array(res1)]
    return result


############################################################
# speech to text
############################################################
def wav_to_raw(wav):
    sound = AudioSegment.from_wav(wav)
    sound = sound.set_channels(1)
    sound.export("./raw/" + wav[8:-4] + '.raw', format="raw")

def raw_to_text(raw):
    openApiURL = "http://aiopen.etri.re.kr:8000/WiseASR/Recognition"
    accessKey = "cbbbb2ef-7dbc-4dae-8727-56f9c5226b97"  # Enter the api key

    try:
        file = open(raw, "rb")
        audioContents = base64.b64encode(file.read()).decode("utf8")
        file.close()

        requestJson = {
            "access_key": accessKey,
            "argument": {
                "language_code": "english",
                "audio": audioContents
            }
        }

        http = urllib3.PoolManager()
        response = http.request(
            "POST",
            openApiURL,
            headers={"Content-Type": "application/json; charset=UTF-8"},
            body=json.dumps(requestJson)
        )

        byte_str = response.data
        dict_str = byte_str.decode("UTF-8")
        dict_data = ast.literal_eval(dict_str)
        text = dict_data['return_object']['recognized']

        f = open("./text/" + raw[6:-4] + ".txt", 'w')
        f.write(text)
        f.close()
    except:
        pass
