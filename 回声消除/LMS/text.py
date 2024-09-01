#!/usr/bin/env python3
# encoding: utf-8
"""
将两个单声道音频合成为一个双声道音频的测试
@author: shy
@contact: hy_shu@qq.com
@application:
@file: 2channel_merge.py
@time: 2022/6/21 15:10
"""

import scipy.io.wavfile as wavfile
import numpy as np
import wave

class merge_2channels():
    """
    用于将两个已经存在的单声道wav音频，合成一个双声道wav音频
    根据两个单声道wav音频的不同之处，能够生成左右声道内容不同的双声道wav文件
    目前还有一些限制，在后续的版本上会进行更新
    限制：目前要求两个单声道音频的参数都相同（时间、采样频率、采样宽度，压缩格式等）

    """

    def __init__(self, merge_framerate, merge_samples, merge_sampwidth=2, merge_channels=2):
        self.merge_framerate = merge_framerate # 采样率
        self.merge_samples = merge_samples # 采样点
        self.merge_sampwidth = merge_sampwidth # 采样宽度，默认2byte
        self.merge_channels = merge_channels # 声道数，因为是生成双声道音频所以默认2

    def save_file(self, filepath, data):
        """
        保存录音文件
        :param filepath: 用于保存的路径(str)
        :param data: 音频数据(2列的ndarray)
        :return:
        """
        wf = wave.open(filepath, 'wb') # 打开目标文件，wb表示以二进制写方式打开，只能写文件，如果文件不存在，创建该文件；如果文件已存在，则覆盖写
        wf.setnchannels(self.merge_channels) # 设置声道数
        wf.setsampwidth(self.merge_sampwidth) # 设置采样宽度
        wf.setframerate(self.merge_framerate) # 设置采样率
        wf.writeframes(data.tostring()) # 将data转换为二进制数据写入文件
        wf.close() # 关闭已打开的文件

    def merge(self, audio_left, audio_right, merge_audio):
        """
        基于两个单声道音频合成一个双声道音频
        :param audio_left: 左声道音频的路径(str)
        :param audio_right: 右声道音频的路径(str)
        :param merge_audio: 合成音频的路径(str)
        :return:
        """
        fs_left, data_left = wavfile.read(audio_left)  # 读取左声道音频数据
        fs_right, data_right = wavfile.read(audio_right)  # 读取右声道音频数据

        data = np.vstack([data_left, data_right])  # 组合左右声道
        data = data.T  # 转置（这里我参考了双声道音频读取得到的格式）
        self.save_file(merge_audio, data) # 保存
import librosa
import soundfile as sf
if __name__ == '__main__':

    # for i in range(1,101):
    #      #name = "LJ001-"+str( "%04d"%(i) )+".wav"
    #      name = ""
    #      src_sig,sr = sf.read("D:/PDS_FPGA/Audio_python_test/回声消除/LMS/伴奏ccy.wav")  #name是要 输入的wav 返回 src_sig:音频数据  sr:原采样频率  
    #      dst_sig = librosa.resample(src_sig,sr,48000)  #resample 入参三个 音频数据 原采样频率 和目标采样频率
    #      sf.write("res/"+name,dst_sig,48000) #写出数据  参数三个 ：  目标地址  更改后的音频数据  目标采样数据

    a = merge_2channels(merge_framerate=48000, merge_samples=2000, merge_sampwidth=2) # 指定相关参数，目前要求单通道音频参数一致
    a.merge('D:/PDS_FPGA/Audio_python_test/回声消除/LMS/x-x2-2.wav', 'D:/PDS_FPGA/Audio_python_test/回声消除/LMS/x-d2-2.wav', 'D:/PDS_FPGA/Audio_python_test/回声消除/LMS/音乐0.2.wav') # 合成

