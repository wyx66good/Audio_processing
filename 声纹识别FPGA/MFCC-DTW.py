"""
author:WenYiXxing
Times:2024.7.23
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
from scipy.fftpack import dct
from scipy.spatial.distance import euclidean
from python_speech_features import mfcc 

# 预加重   s′(n)=s(n)－as(n－1)(a为常数)su
def pre_add(x):  # 定义预加重函数
    signal_points=len(x)  # 获取语音信号的长度
    signal_points=int(signal_points)  # 把语音信号的长度转换为整型
    for i in range(1, signal_points, 1):# 对采样数组进行for循环计算
        x[i] = x[i] - 0.9175 * x[i - 1]  # 一阶FIR滤波器
    return x  # 返回预加重以后的采样数组

wlen=1024#分帧帧长
inc =512#帧移长度
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

def PA_PB(data,n=5):
    PA_SUM=0
    PB_SUM=0
    for i in range (n):
        sum=0
        z_sum=0
        sum=np.sum(data[i]*data[i])
        PA_SUM=PA_SUM+sum

        for i_1 in range (1024):
            if (data[i][i_1]>=0) :sgn=1
            else:sgn=-1
            if (data[i][i_1-1]>=0) :sgn_1=1
            else:sgn_1=-1
            z_sum=z_sum+np.abs(sgn-sgn_1)
        PB_SUM=PB_SUM+z_sum

    PA=PA_SUM/n #短时能量
    PB=PB_SUM/n #短时过零率

    return PA,PB

def PA_PB_1(data):
    PA_SUM=0
    PB_SUM=0
    sum=0
    z_sum=0
    sum=np.sum(data*data)
    PA_SUM=sum
    for i_1 in range (1024):
        if (data[i_1]>=0) :sgn=1
        else:sgn=-1
        if (data[i_1-1]>=0) :sgn_1=1
        else:sgn_1=-1
        z_sum=z_sum+np.abs(sgn-sgn_1)
    PB_SUM=z_sum/2

    PA=PA_SUM #短时能量
    PB=PB_SUM #短时过零率

    return PA,PB
def point(data,nf,n,PA_SET,PB_SET):
    a=1
    i_1=0
    PA,PB=0,0
    data_out=np.zeros((int(nf),wlen))
    for i in range (n,nf):
        # a=a+1
        # if(a==5):
        PA,PB=PA_PB_1(data[i])
            # a=1
        if(PA>PA_SET):
            data_out[i_1]=data[i]
            i_1=i_1+1
    return data_out[:i_1+1],i_1+1

def MFCC(sr,NFFT,nfilt):
        low_freq_mel = 0
        high_freq_mel = (2595 * np.log10(1 + (sr / 2) / 700))  # 求最高hz频率对应的mel频率
        # 我们要做40个滤波器组，为此需要42个点，这意味着在们需要low_freq_mel和high_freq_mel之间线性间隔40个点
        mel_points = np.linspace(low_freq_mel, high_freq_mel, nfilt + 2)  # 在mel频率上均分成42个点
        hz_points = (700 * (10 ** (mel_points / 2595) - 1))  # 将mel频率再转到hz频率
        # bin = sample_rate/2 / NFFT/2=sample_rate/NFFT    # 每个频点的频率数
        # bins = hz_points/bin=hz_points*NFFT/ sample_rate    # hz_points对应第几个fft频点
        bins = np.floor((NFFT + 1) * hz_points / sr)
        
        fbank1 = np.zeros((nfilt, int(np.floor(NFFT / 2 + 1))))
        fbank = np.zeros((nfilt, int(np.floor(NFFT /2))))
        for m in range(1, nfilt + 1):
            f_m_minus = int(bins[m - 1])  # 左
            f_m = int(bins[m])  # 中
            f_m_plus = int(bins[m + 1])  # 右
        
            for k in range(f_m_minus, f_m):
                fbank1[m - 1, k] = (k - bins[m - 1]) / (bins[m] - bins[m - 1])
            for k in range(f_m, f_m_plus):
                fbank1[m - 1, k] = (bins[m + 1] - k) / (bins[m + 1] - bins[m])
        fbank=fbank1[:,:512]
        # fbank[:,511:]=fbank1[:,::-1]
        return fbank
def MFCCS(data,melbank,nfilt,nf,wlen):
    Y_MFCC = np.zeros((nf,nfilt ))
    for i in range (13):
        for i_1 in range(nf):
            Y_MFCC[i_1][i]=sum(data[i_1]*melbank[i])
    return Y_MFCC

def DCT(data_log,nf,nfilt):
    c=np.zeros((nf,nfilt ))
    i_2=0
    for i_2 in range(nfilt):
        for i in range(nf):
            for i_1 in range(nfilt):
                c[i][i_2]=c[i][i_2]+data_log[i][i_1]*np.cos((i_1-0.5)*(i_2)*np.pi/nfilt)
    return c

def MFCC_DCT(y_fft1_test,nf_test1,nfilt):
    melbank=MFCC(48000,1024,nfilt)
    Y_MFCC1=MFCCS(y_fft1_test,melbank,nfilt,nf_test1,512)
    Y_MFCC1_LOG=np.log10(Y_MFCC1)
    where_are_inf = np.isinf(Y_MFCC1_LOG)
    Y_MFCC1_LOG[where_are_inf]=0
    Y_MFCC1_DCT=DCT(Y_MFCC1_LOG,nf_test1,nfilt)[:,1:]

    return Y_MFCC1_DCT


def distance(data1,data2,n=12):
    sum=0
    for i in range (n):
        sum=sum+np.abs(((data1[i]-data2[i])))
    d=sum
    return d

def DTW(DATA1,NF1,DATA2,NF2):
    X=0
    Y=0
    D=0
    path = []
    M=2*NF1-NF2
    N=2*NF2-NF1
    if(M>=3 and N>=2):
        while(1):
            A=distance(DATA1[X+1],DATA2[Y+2])
            B=distance(DATA1[X+1],DATA2[Y+1])
            C=distance(DATA1[X+2],DATA2[Y+1])
    
            if(A<B and A<C):
                if(X>=NF1-4):
                    X=NF1-4 
                    Y=Y+1
                elif(Y>=NF2-4):  
                    X=X+1
                    Y=NF2-4
                else:
                    X=X+1 
                    Y=Y+2
                D=D+A
            elif(B<=A and B<=C):
                if(X>=NF1-4):
                    X=NF1-4 
                    Y=Y+1
                elif(Y>=NF2-4):  
                    X=X+1
                    Y=NF2-4
                else:
                    X=X+1 
                    Y=Y+1
                D=D+B
            else:
                if(X>=NF1-4):
                    X=NF1-4 
                    Y=Y+1
                elif(Y>=NF2-4):  
                    X=X+1
                    Y=NF2-4
                else:
                    X=X+2 
                    Y=Y+1
                D=D+C
            if(X>=NF1-4 and Y>=NF2-4):
                break
            path.append((X,Y))   
    else :
         while(1):
            A=distance(DATA1[X],DATA2[Y+1])
            B=distance(DATA1[X+1],DATA2[Y+1])
            C=distance(DATA1[X+1],DATA2[Y])
    
            if(A<B and A<C):
                if(X>=NF1-4):
                    X=NF1-4 
                    Y=Y+1
                elif(Y>=NF2-4):  
                    X=X+1
                    Y=NF2-4
                else:
                    X=X
                    Y=Y+1
                D=D+A
            elif(B<=A and B<=C):
                if(X>=NF1-4):
                    X=NF1-4 
                    Y=Y+1
                elif(Y>=NF2-4):  
                    X=X+1
                    Y=NF2-4
                else:
                    X=X+1 
                    Y=Y+1
                D=D+B
            else:
                if(X>=NF1-4):
                    X=NF1-4 
                    Y=Y+1
                elif(Y>=NF2-4):  
                    X=X+1
                    Y=NF2-4
                else:
                    X=X+1 
                    Y=Y
                D=D+C
            if(X>=NF1-4 and Y>=NF2-4):
                break
            path.append((X,Y))    
    return D,path,math.sqrt(NF1*NF1+NF2*NF2)





if __name__ == '__main__':
    y_test1, sr_test1 = librosa.load(path="D:/PDS_FPGA/Audio_python_test/声纹识别FPGA/D 声纹识别测试音频/测试样本/1.m4a", sr=48000, offset=0.0, duration=None)
    y_test2, sr_test2 = librosa.load(path="D:/PDS_FPGA/Audio_python_test/声纹识别FPGA/D 声纹识别测试音频/测试样本/26.m4a", sr=48000, offset=0.0, duration=None)
    y_test3, sr_test3 = librosa.load(path="D:/PDS_FPGA/Audio_python_test/声纹识别FPGA/D 声纹识别测试音频/测试样本/40.m4a", sr=48000, offset=0.0, duration=None)
    y_test4, sr_test4 = librosa.load(path="D:/PDS_FPGA/Audio_python_test/声纹识别FPGA/D 声纹识别测试音频/测试样本/63.m4a", sr=48000, offset=0.0, duration=None)


    y_train, sr_train = librosa.load(path="D:/PDS_FPGA/Audio_python_test/声纹识别FPGA/D 声纹识别测试音频/测试比对库/7.m4a", sr=48000, offset=0.0, duration=None)
  
    y_test1=pre_add(y_test1)
    y_test2=pre_add(y_test2)
    y_test3=pre_add(y_test3)
    y_test4=pre_add(y_test4)
    y_train=pre_add(y_train)

    y_test1_f,nf_test1=Framing_fun(y_test1)
    y_test2_f,nf_test2=Framing_fun(y_test2)
    y_test3_f,nf_test3=Framing_fun(y_test3)
    y_test4_f,nf_test4=Framing_fun(y_test4)
    y_train_f,nf_train=Framing_fun(y_train)
    
    hanning_windown=np.hanning(wlen)  #调用汉明窗

    y_test1_f=y_test1_f*hanning_windown
    y_test2_f=y_test2_f*hanning_windown
    y_test3_f=y_test3_f*hanning_windown
    y_test4_f=y_test4_f*hanning_windown
    y_train_f=y_train_f*hanning_windown

    #阈值
    PA_TEST1,PB_TEST1=PA_PB(y_test1_f,45)
    PA_TEST2,PB_TEST2=PA_PB(y_test2_f,45)
    PA_TEST3,PB_TEST3=PA_PB(y_test3_f,45)
    PA_TEST4,PB_TEST4=PA_PB(y_test4_f,45)
    PA_TRAIN4,PB_TRAIN4=PA_PB(y_train_f,45)

    y_point1_test,nf_test1=point(y_test1_f,nf_test1,45,PA_TEST1,PB_TEST1)
    y_point2_test,nf_test2=point(y_test2_f,nf_test2,45,PA_TEST2,PB_TEST2)
    y_point3_test,nf_test3=point(y_test3_f,nf_test3,45,PA_TEST3,PB_TEST3)
    y_point4_test,nf_test4=point(y_test4_f,nf_test4,45,PA_TEST4,PB_TEST4)
    y_point_train,nf_train=point(y_train_f,nf_train,45,PA_TRAIN4,PB_TRAIN4)

    y_fft1_test=np.abs(np.fft.rfft(y_point1_test,1024)[:,1:])**2
    y_fft2_test=np.abs(np.fft.rfft(y_point2_test,1024)[:,1:])**2
    y_fft3_test=np.abs(np.fft.rfft(y_point3_test,1024)[:,1:])**2
    y_fft4_test=np.abs(np.fft.rfft(y_point4_test,1024)[:,1:])**2
    y_fft_train=np.abs(np.fft.rfft(y_point_train,1024)[:,1:])**2
    
    Y_MFCC1_DCT=MFCC_DCT(y_fft1_test,nf_test1,13)
    Y_MFCC2_DCT=MFCC_DCT(y_fft2_test,nf_test2,13)
    Y_MFCC3_DCT=MFCC_DCT(y_fft3_test,nf_test3,13)
    Y_MFCC4_DCT=MFCC_DCT(y_fft4_test,nf_test4,13)

    Y_MFCC_DCT=MFCC_DCT(y_fft_train,nf_train,13)

    D1,PATH1,D1_min=DTW(Y_MFCC1_DCT,nf_test1,Y_MFCC_DCT,nf_train)
    D2,PATH2,D2_min=DTW(Y_MFCC2_DCT,nf_test2,Y_MFCC_DCT,nf_train)
    D3,PATH3,D3_min=DTW(Y_MFCC3_DCT,nf_test3,Y_MFCC_DCT,nf_train)
    D4,PATH4,D4_min=DTW(Y_MFCC4_DCT,nf_test4,Y_MFCC_DCT,nf_train)

    # print("D1_min=",D1_min)
    # print("D2_min=",D2_min)
    # print("D3_min=",D3_min)
    # print("D4_min=",D4_min)

    print("D1=",D1)
    print("D2=",D2)
    print("D3=",D3)
    print("D4=",D4)


    # error1=D1-D1_min
    # error2=D2-D2_min
    # error3=D3-D3_min
    # error4=D4-D4_min

    # print("error1=",error1)
    # print("error2=",error2)
    # print("error3=",error3)
    # print("error4=",error4)
    # data_out1=data_out[:,:512]
    # mfcc_feature = mfcc(y_test1, sr_test1, winlen=0.02133, winstep=0.01, nfilt=13, nfft=1024,appendEnergy=False)
    # d=dct(Y_MFCC1_LOG,type = 2,axis = 0,norm = 'ortho')[:,:13]

    # data_out_list=list(np.array(melbank).flatten())
    # sf.write("D:/PDS_FPGA/Audio_python_test/声纹识别FPGA/测试语音集/point2.wav", data_out_list, 48000)




    # data_out_list1=list(np.array(y_point1_test).flatten())
    # data_out_list2=list(np.array(y_point2_test).flatten())
    # data_out_list3=list(np.array(y_point3_test).flatten())
    # data_out_list4=list(np.array(y_point4_test).flatten())
    # data_out_list5=list(np.array(y_point_train).flatten())

    # fig = plt.figure('y',figsize = (10,10)).add_subplot(511)
    # fig.plot(y_test1,color='y')
    # fig = plt.figure('y',figsize = (10,10)).add_subplot(512)
    # fig.plot(y_test2,color='y')
    # fig = plt.figure('y',figsize = (10,10)).add_subplot(513)
    # fig.plot(y_test3,color='y')
    # fig = plt.figure('y',figsize = (10,10)).add_subplot(514)
    # fig.plot(y_test4,color='y')
    # fig = plt.figure('y',figsize = (10,10)).add_subplot(515)
    # fig.plot(y_train,color='y')

    # figY2 = plt.figure('y2',figsize = (10,10)).add_subplot(511)
    # figY2.plot(data_out_list1,color='y')
    # figY2 = plt.figure('y2',figsize = (10,10)).add_subplot(512)
    # figY2.plot(data_out_list2,color='y')
    # figY2 = plt.figure('y2',figsize = (10,10)).add_subplot(513)
    # figY2.plot(data_out_list3,color='y')
    # figY2 = plt.figure('y2',figsize = (10,10)).add_subplot(514)
    # figY2.plot(data_out_list4,color='y')
    # figY2 = plt.figure('y2',figsize = (10,10)).add_subplot(515)
    # figY2.plot(data_out_list5,color='y')

    # fig2 = plt.figure('point',figsize = (10,10)).add_subplot(511)
    # fig2.plot(y_train,color='y')
    # fig2 = plt.figure('point',figsize = (10,10)).add_subplot(512)
    # for i in range (13):
    # # fig2.plot(melbank[0],color='y')
    #     fig2.plot(melbank[i],color='b')
    # fig3 = plt.figure('D',figsize = (10,10)).add_subplot(511)
    # fig3.plot(PATH1[1],PATH1[2],color='y')
    # fig3 = plt.figure('D',figsize = (10,10)).add_subplot(512)
    # fig3.plot(PATH2[1],PATH2[2],color='y')
    # fig3 = plt.figure('D',figsize = (10,10)).add_subplot(513)
    # fig3.plot(PATH3[1],PATH3[2],color='y')
    # fig3 = plt.figure('D',figsize = (10,10)).add_subplot(514)
    # fig3.plot(PATH4[1],PATH4[2],color='y')
    # # fig3 = plt.figure('y',figsize = (10,10)).add_subplot(515)
    # # fig3.plot(y_train,color='y')
    # plt.show()
