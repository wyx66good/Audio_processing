"""
author:WenYiXxing
Times:2024.6.5

人声分离
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
from scipy import signal

# 分帧
wlen=1024#分帧帧长
inc =512#帧移长度
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



y, sr = librosa.load(path="D:/PDS_FPGA/Audio_python_test/人声分离/人声分离测试音频样本.m4a", sr=48000, offset=0.0, duration=None)#人声分离测试音频样本.m4a

# y=y*40000

data,nf=Framing_fun(y)
hanning_windown=np.hanning(wlen)  #调用海明窗

# data=data*hanning_windown

leny=len(y)
W=[0]*1024*nf
W_fft=[0]*1024*nf
H=[0]*leny
P=[0]*leny
M=[0]*leny
M2=[0]*leny
PHASE=[0]*1024*nf
data_w=np.zeros((nf,1024))
data_w_fft=np.zeros((nf,1024),dtype=complex)
data_w_fft2=np.zeros((nf,1024),dtype=complex)
data_h_fft=np.zeros((nf,1024),dtype=complex)
data_p_fft=np.zeros((nf,1024),dtype=complex)
data_h=np.zeros((nf,1024))
data_p=np.zeros((nf,1024))
data_h_1=np.zeros((nf,1024))
data_p_1=np.zeros((nf,1024))
c_m=np.zeros((nf,1024))
c_v=np.zeros((nf,1024))
for i in range (nf):
    Y_fft=[0]*1024
    Y_abs=[0]*1024
    Y_abs1=[0]*1024
    Y_fft=np.fft.fft(data[i],NFFT)
    PHASE[i*1024:i*1024+1024] = np.angle(Y_fft) 
    Y_abs=np.abs(Y_fft)*np.abs(Y_fft)
    Y_abs1=np.abs(Y_fft)
    # Y_fft_real=Y_fft.real
    for i_1 in range (1024):
        data_w[i][i_1]=Y_abs[i_1]
        data_h[i][i_1]=data_w[i][i_1]/2
        data_p[i][i_1]=data_w[i][i_1]/2
    data_w_fft[i]=Y_fft

data_m=np.zeros((nf,1024))
data_m2=np.zeros((nf,1024))
wavoutE=[0]*leny
wavoutA=[0]*leny

a=0.6
k=15#迭代次数
for k_i in range (k):
    for i in range (nf-1):
        b=[0]*1024
        for i_1 in range (1024-1):
            b[i_1]=a*(data_h[i-1][i_1]-2*data_h[i][i_1]+data_h[i+1][i_1])/4 - (1-a)*(data_p[i][i_1-1]-2*data_p[i][i_1]+data_p[i][i_1+1])/4
        
        for i_1 in range (1024):
            data_h_1[i][i_1]=data_h[i][i_1]+b[i_1]
        # for i_1 in range (1024):
        #     data_p_1[i][i_1]=data_w[i][i_1]-data_h_1[i][i_1]
    data_h=data_h_1
    # data_p=data_p_1
    for i in range (nf):  
        for i_1 in range (1024):
            if(data_h[i][i_1]>=0 and data_h[i][i_1]<=data_w[i][i_1]):
                data_h[i][i_1]=data_h[i][i_1]
            elif(data_h[i][i_1]<0):
                data_h[i][i_1]=0
            elif(data_h[i][i_1]>data_w[i][i_1]):
                data_h[i][i_1]=data_w[i][i_1]
    data_p=data_w-data_h

# data_h = signal.medfilt(data_w, [1, 5])
# data_p = signal.medfilt(data_w, [5, 1])

# from scipy import signal
# L_h = 15; #Harmonic (Horizontal) Median Filter Length
# L_p = 13; #Percussive (Vertical) Median Filter Length
# data_h = signal.medfilt(data_w, [1, L_h]) #Median Filter in Horizontal Direction (Harmonic)
# data_p = signal.medfilt(data_w, [L_p, 1]) #Median Filter in Vertical Direction (Percussive)
# M_h = np.int8(data_h >= data_p) #Binary Mask for Harmonic Components
# M_p = np.int8(data_h < data_p) #Binary Mask for Percussive Components
# X_h = data_w_fft * M_h; #Harmonic Components
# X_p = data_w_fft * M_p; #Percussive Components

for i in range (nf):
    # for i_1 in range (1024):
    #     # data_m[i][i_1]=data_h[i][i_1]*data_h[i][i_1]/(data_h[i][i_1]*data_h[i][i_1]+data_p[i][i_1]*data_p[i][i_1])
    #     # data_m2[i][i_1]=data_p[i][i_1]*data_p[i][i_1]/(data_h[i][i_1]*data_h[i][i_1]+data_p[i][i_1]*data_p[i][i_1])
    #     # data_m[i][i_1] =(data_h[i][i_1])/((data_h[i][i_1])+(data_p[i][i_1]))
    #     # data_m2[i][i_1]=(data_p[i][i_1])/((data_h[i][i_1])+(data_p[i][i_1]))
    #     data_m[i][i_1] =np.abs(data_h[i][i_1])/(np.abs(data_h[i][i_1])+np.abs(data_p[i][i_1]))
    #     data_m2[i][i_1]=np.abs(data_p[i][i_1])/(np.abs(data_h[i][i_1])+np.abs(data_p[i][i_1]))
    for i_1 in range (1024):
        if(data_h[i][i_1]>=data_p[i][i_1]):
            data_h_fft[i][i_1]=data_w_fft[i][i_1]
            data_p_fft[i][i_1]=0
        else:
            data_h_fft[i][i_1]=0
            data_p_fft[i][i_1]=data_w_fft[i][i_1]

    # for i_1 in range (wlen):
    #     data_h_fft[i][i_1]=data_w_fft[i][i_1]*(data_m[i][i_1])
    # for i_1 in range (wlen):
    #     data_p_fft[i][i_1]=data_w_fft[i][i_1]*data_m2[i][i_1]


    # M_h = np.int8(data_h[i] >= data_p[i]) #Binary Mask for Harmonic Components
    # M_p = np.int8(data_h[i] < data_p[i]) #Binary Mask for Percussive Components
    # data_h_fft[i] = data_w_fft[i] * M_h; #Harmonic Components
    # data_p_fft[i] = data_w_fft[i] * M_p; #Percussive Components


x_h=np.zeros  (nf*wlen)
x_p=np.zeros  (nf*wlen )
x_h_5=np.zeros(nf*wlen)
x_p_5=np.zeros(nf*wlen)
x_h_6=np.zeros(nf*wlen)
x_p_6=np.zeros(nf*wlen)
x_h_7=np.zeros(nf*wlen)
x_p_7=np.zeros(nf*wlen)
for i in range (nf):
    p= np.fft.ifft(data_h_fft[i]).real*hanning_windown
    x_h_5 [i*inc:i*inc+wlen]= x_h_5 [i*inc:i*inc+wlen]+p
    x_h_6=[0]*nf*wlen
    x_h_6 [i*inc:i*inc+wlen]=hanning_windown*hanning_windown
    x_h_7[i*inc:i*inc+wlen]=x_h_7[i*inc:i*inc+wlen]+x_h_6[i*inc:i*inc+wlen]
    p1= np.fft.ifft(data_p_fft[i]).real*hanning_windown
    x_p_5 [i*inc:i*inc+wlen]= x_p_5 [i*inc:i*inc+wlen]+p1
    x_p_6=[0]*nf*wlen
    x_p_6 [i*inc:i*inc+wlen]=hanning_windown*hanning_windown
    x_p_7[i*inc:i*inc+wlen]=x_p_7[i*inc:i*inc+wlen]+x_p_6[i*inc:i*inc+wlen]
# x_h_7[x_h_7 == 0] = np.finfo(np.float32).eps
x_h=x_h_5/x_h_7
x_p=x_p_5/x_p_7
# datap=[0]*wlen
# for i in range(nf-1):#调制加滤波
#     for i_1 in range(wlen):
#             # data4[i][i_1]=data2[i][i_1]*sin_data[i_1]/128
#             a=0.9*128
#             datap[i_1]=c_v[i][i_1]*sin_data[i_1]*a
#             c_v[i][i_1]=c_v[i][i_1-1] *(128-a)/128 +datap[i_1]/16384
            
for i in range (nf): 
    wavoutA[i*1024:i*1024+1024]= c_v[i]
    wavoutE[i*1024:i*1024+1024]= c_m[i]
    M[i*1024:i*1024+1024]= data_m[i]

pp=[0]*1024
pp=data_m[59]



sf.write("D:/PDS_FPGA/Audio_python_test/人声分离/人声分离测试音频样本_E-mid.wav",  x_h,sr)#读出音频
sf.write("D:/PDS_FPGA/Audio_python_test/人声分离/人声分离测试音频样本_A-mid.wav",  x_p,sr)#读出音频


fig6 = plt.figure('TD-PSOLA',figsize = (8,8)).add_subplot(411)
fig6.plot(y,color='c')
fig6 = plt.figure('TD-PSOLA',figsize = (8,8)).add_subplot(412)
fig6.plot(y,color='c')
fig6.plot(x_h[:492000],color='b')
fig6 = plt.figure('TD-PSOLA',figsize = (8,8)).add_subplot(413)
fig6.plot(y,color='c')
fig6.plot(x_p[:492000],color='b')
fig7 = plt.figure('aaa',figsize = (8,8)).add_subplot(412)
fig7.plot(data_p_fft[59],color='b')
fig7.plot(data_w_fft[59],color='y')
fig7 = plt.figure('aaa',figsize = (8,8)).add_subplot(413)
fig7.plot(data_h_fft[59],color='b')
fig7.plot(data_w_fft[59],color='y')
fig7 = plt.figure('aaa',figsize = (8,8)).add_subplot(414)
fig7.plot(pp,color='b')
plt.show()
    
