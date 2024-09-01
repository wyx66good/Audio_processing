#!/user/bin/env python
# coding=utf-8
"""
@project : batch-pro
@author  : 剑客阿良_ALiang
@file   : audio_tool.py
@ide    : PyCharm
@time   : 2021-12-21 14:48:18
"""
from ffmpy import FFmpeg
 
import os
 
 
# MP3转wav
def audio_transfor(audio_path: str, output_dir: str):
    ext = os.path.basename(audio_path).strip().split('.')[-1]
    if ext != 'mp3':
        raise Exception('format is not mp3')
 
    result = os.path.join(output_dir, '{}.{}'.format(os.path.basename(audio_path).strip().split('.')[0], 'wav'))
    filter_cmd = '-f wav -ac 1 -ar 16000'
    ff = FFmpeg(
        inputs={
            audio_path: None}, outputs={
            result: filter_cmd})
    print(ff.cmd)
    ff.run()
    return result
 
 
def handle(audio_dir: str, output_dir: str):
    for x in os.listdir(audio_dir):
        audio_transfor(os.path.join(audio_dir, x), output_dir)