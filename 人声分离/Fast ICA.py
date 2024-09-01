"""
author:WenYiXxing
Times:2024.6.5

人声分离Fast ICA
"""

import numpy as np
import matplotlib.pyplot as plt  # 导入绘图工作的函数集合
# from pydub import AudioSegment
import librosa.display  # 导入音频及绘图显示
import math
from scipy.fftpack import dct, idct
from scipy.io import wavfile
import soundfile as sf
import wave
from dtw import dtw
from scipy.spatial.distance import euclidean
# import torchaudio
from sklearn.decomposition import NMF

# 分帧
wlen=1024#分帧帧长
inc =1024#帧移长度
NFFT =wlen

def Framing_fun(data):
    signal_len=len(data)# 获取语音信号的长度
    if signal_len<=wlen: 
        nf=1
    else:                
        nf=int(np.ceil((1.0*signal_len-wlen+inc)/inc))
    pad_len=int((nf-1)*inc+wlen) 
    zeros=np.zeros((pad_len-signal_len,))#补0
    pad_data=np.concatenate((data,zeros)) 
    indices=np.tile(np.arange(0,wlen),(nf,1))+np.tile(np.arange(0,nf*inc,inc),(wlen,1)).T  #相当于对所有帧的时间点进行抽取，得到nf*wlen长度的矩阵
    indices=np.array(indices,dtype=np.int32) #将indices转化为矩阵
    frames=pad_data[indices] #得到帧信号
    return frames,nf

def zhongxinghua(data):
    leny=len(data)
    y_sum=np.sum(y)
    y_p=y_sum/leny
    y_zhongxinghua=np.zeros(leny)
    for i in range (leny):
        y_zhongxinghua[i]=y[i]-y_p
    return y_zhongxinghua

y, sr = librosa.load(path="D:/PDS_FPGA/Audio_python_test/人声分离/人声分离测试音频样本.m4a", sr=48000, offset=0.0, duration=None)


# y=y*40000

data,nf=Framing_fun(y)
Y=[0]*len(y)
for i in range (nf):
    Y_fft=[0]*1024
    Y_abs=[0]*1024
    Y_fft=np.fft.fft(data[i],NFFT) 
    Y_abs=np.abs(Y_fft)*np.abs(Y_fft)
    Y[i*1024:i*1024+1024]=Y_abs
nmf = NMF(
          init=None,  # W H 的初始化方法，包括'random' | 'nndsvd'(默认) |  'nndsvda' | 'nndsvdar' | 'custom'.
          solver='cd',  # 'cd' | 'mu'
          beta_loss='frobenius',  # {'frobenius', 'kullback-leibler', 'itakura-saito'}，一般默认就好
          tol=1e-4,  # 停止迭代的极限条件
          max_iter=200,  # 最大迭代次数
          random_state=None,
          l1_ratio=0.,  # 正则化参数
          verbose=0,  # 冗长模式
          shuffle=False  # 针对"cd solver"
          )

# 下面四个函数很简单，也最核心，例子中见
nmf.fit(data)
W = nmf.fit_transform(data)
W = nmf.transform(data)
nmf.inverse_transform(W)
# -----------------属性------------------------
H = nmf.components_  # H矩阵


sf.write("D:/PDS_FPGA/Audio_python_test/人声分离/nmf_E.wav",  W,sr)#读出音频
sf.write("D:/PDS_FPGA/Audio_python_test/人声分离/nmf_A.wav",  H,sr)#读出音频

a=1