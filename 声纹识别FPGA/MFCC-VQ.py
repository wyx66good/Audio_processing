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
    pre=np.zeros(signal_points)
    pre[0]=x[0]
    for i in range(1, signal_points, 1):# 对采样数组进行for循环计算
        pre[i] = x[i] - 0.9375 * x[i - 1]  # 一阶FIR滤波器
    return pre  # 返回预加重以后的采样数组

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
def melBank(p=24,NFFT=256,fs=8000):
    # 最低频率
    fl = 0
    # 最高频率
    fh = fs/2
    # 把 Hz 变成 Mel
    bl = 1125*np.log(1+fl/700)
    bh = 1125*np.log(1+fh/700)
    # 最高mel频率和最低mel频率之差
    B = bh-bl
    # 将梅尔刻度等间隔
    y = np.linspace(0,B,p+2)
    #print(y)
    # 把 Mel 变成 Hz
    Fb = 700*(np.exp(y/1125)-1)
    #print(Fb)
    # fs/2内对应的FFT点数
    W2 = int(NFFT / 2 + 1)
    # 分帧
    df = fs/NFFT
    freq = []#采样频率值
    for n in range(0,W2):
        freqs = int(n*df)
        freq.append(freqs)
    # mel滤波器组
    bank = np.zeros((24,W2))

    for k in range(1,p+1):

        f1 = Fb[k-1]
        f2 = Fb[k+1]
        f0 = Fb[k]
        n1=np.floor(f1/df)
        n2=np.floor(f2/df)
        n0=np.floor(f0/df)
        for i in range(1,W2):
            if i>=n1 and i<=n0:
                bank[k-1,i]=(i-n1)/(n0-n1)
            elif i>n0 and i<=n2:
                bank[k-1,i]=(n2-i)/(n2-n0)
        # print(k)
        # print(bank[k-1,:])
        # plt.plot(freq,bank[k-1,:],'r')
    # plt.show()
    return bank


def MFCCS(data,melbank,nfilt,nf,wlen):
    Y_MFCC = np.zeros((nf,nfilt ))
    for i in range (24):
        for i_1 in range(nf):
            Y_MFCC[i_1][i]=sum(data[i_1]*melbank[i])
    return Y_MFCC

def DCT(data_log,nf,nfilt):
    c=np.zeros((nf,nfilt ))
    dctcoef = np.zeros([13, 24])
    # print(dctcoef)
    # DCT系数，12(欲求的mfcc个数)×24
    for i in range(1, 14):
        n = np.array(range(24))
        dctcoef[i - 1] = np.cos(np.pi * i * (2 * n + 1) / (2 * 24))
    i_2=0
    for i_2 in range(nfilt):
        for i in range(nf):
            for i_1 in range(24):
                c[i][i_2]=c[i][i_2]+data_log[i][i_1]*dctcoef[i_2][i_1]
    return c

def MFCC_DCT(y_fft1_test,nf_test1,nfilt):
    melbank=melBank(24,1024,48000)[:,:512]*256
    
    # hex__num = hex(melbank[0])[2: ].zfil1(2)
    # b = [hex(i) for i in int(melbank[0])]
    # #定义数据
    # np.savetxt( ' result.dat', b)

    Y_MFCC1=MFCCS(y_fft1_test,melbank,24,nf_test1,512)
    Y_MFCC1_LOG=np.log10(Y_MFCC1)
    where_are_inf = np.isinf(Y_MFCC1_LOG)
    Y_MFCC1_LOG[where_are_inf]=0
    Y_MFCC1_DCT=DCT(Y_MFCC1_LOG,nf_test1,nfilt)#[:,1:]

    return Y_MFCC1_DCT


def distance(data1,data2,n=13):
    sum=0
    for i in range (n):
        sum=sum+(np.abs(data1[i]-data2[i]))
    d=sum
    return d
def fenlei(data,epision):#分裂
    data[15]=data[7]*(1+epision)
    data[14]=data[7]*(1-epision)
    data[13]=data[6]*(1+epision)
    data[12]=data[6]*(1-epision)
    data[11]=data[5]*(1+epision)
    data[10]=data[5]*(1-epision)
    data[9 ]=data[4]*(1+epision)
    data[8 ]=data[4]*(1-epision)
    data[7 ]=data[3]*(1+epision)
    data[6 ]=data[3]*(1-epision)
    data[5 ]=data[2]*(1+epision)
    data[4 ]=data[2]*(1-epision)
    data[3 ]=data[1]*(1+epision)
    data[2 ]=data[1]*(1-epision)
    data[1 ]=data[0]*(1+epision)
    data[0 ]=data[0]*(1-epision)
    return data


def VQ_lbg(MFCC,NF1,nfilt,K,epision,delta):
    VQ_lbg=np.zeros((K,nfilt ))
    VQ_lbg_mfcc=np.zeros((K,NF1,nfilt ))
    VQ_lbg_mfcc_add=np.zeros((K))
    sum=np.zeros((K ))
    a=0
    for i in range (nfilt):
        VQ_lbg[0][i]=np.sum(MFCC[:,i])/NF1
    for i_1 in range(1,int(math.log2(K))+1):
        VQ_lbg=fenlei(VQ_lbg,epision)
        D1=1
        D2=2
        while(np.abs(D1-D2)/D1>delta):
            a=a+1
            D2=D1
            D1=0
            VQ_lbg_mfcc=np.zeros((K,NF1,nfilt ))
            VQ_lbg_mfcc_add=np.zeros((K))
            for i_3 in range(NF1):
                sum=np.zeros((K ))
                for i_2 in range(pow(2,i_1)):
                    sum[i_2]=distance(MFCC[i_3],VQ_lbg[i_2])
                pos=sum[:pow(2,i_1)].argmin()
                VQ_lbg_mfcc[pos][int(VQ_lbg_mfcc_add[pos])]=MFCC[i_3]
                VQ_lbg_mfcc_add[pos]=VQ_lbg_mfcc_add[pos]+1
            for i_4 in range(pow(2,i_1)):#更新值
                for i_5 in range (nfilt):
                    VQ_lbg[i_4][i_5]=np.sum(VQ_lbg_mfcc[i_4][:,i_5])/int(VQ_lbg_mfcc_add[i_4]+1)
            for i_2 in range(nfilt):
                D11=np.zeros((pow(2,i_1)))
                for i in range(pow(2,i_1)):
                    D11[i]=distance(MFCC[i_2],VQ_lbg[i])
                D1=D1+np.min(D11)
                # for i_6 in range(int(VQ_lbg_mfcc_add[i_4])):
                #     D1=D1+distance(VQ_lbg_mfcc[i_4][i_6],VQ_lbg[i_4])
    return VQ_lbg

class VQ:
    def __init__(self,num,ele):
        self.num=num
        self.ele=ele
        self.mea=0   
def dist(u,xi):
    k=np.size(u,1)
    xi=xi.T
    dist=np.zeros(k)
    for i in range(k):
        ui=u[:,i]
        dist[i]=np.sum((xi-ui)**2)
    return dist        
def lbg(x,k):
    row,col=x.shape
    epision=0.03
    delta=0.0001
    # LBG算法产生k个中心
    u=np.mean(x,1)
    u=np.reshape(u,(len(u),1))
    for i3 in range(int(math.log2(k))):
        u=np.hstack((u*(1-epision),u*(1+epision)))
        D=1
        DD=2
        while abs(D-DD)/D>delta:
            DD=D
            D=0
            v=[]
            for i in range(pow(2,i3+1)):
                v.append(VQ(0,np.zeros(row)))
            for i in range(col):#样本分类
                distance=dist(u,x[:,i])
                pos=distance.argmin()
                val=distance[pos]
                v[pos].num=v[pos].num+1
                if v[pos].num==1:
                    v[pos].ele=x[:,i]
                else:
                    v[pos].ele=np.vstack((v[pos].ele, x[:,i]))
            for i in range(pow(2,i3+1)):
                u=u.T
                uu=np.mean(v[i].ele,0)
                u[i]= uu
                u=u.T
                for m in range(len(v[i].ele)):
                    # print(i,m)
                    D+=np.sum((v[i].ele[m]-u[:,i])**2)
    for i in range(k):
        v[i].mea=u[:,i]
    return v
# dctcoef = np.zeros([13, 24])
# # print(dctcoef)
# # DCT系数，12(欲求的mfcc个数)×24
# for i in range(1, 14):
#     n = np.array(range(24))
#     dctcoef[i - 1] = np.cos(np.pi * i * (2 * n + 1) / (2 * 24))*255

# data_out_list=list(np.array(dctcoef).flatten())
# fig3 = plt.figure('y',figsize = (10,10)).add_subplot(515)
# fig3.plot(data_out_list,color='y')
# plt.show()
# # melbank=melBank(24,1024,48000)[:,:512]*255
# # # hex__num=np.zeros(512)
# # # for i in range(512):
# # #     a=int(melbank[0][i])
# # #     hex__num[i] = hex(a)[2: ]
# # for i2 in range(13):
# #     with open( 'dct'+f"{i2}"+'.dat', 'w') as f:
# #         for i in range(24):
# #             hex_str = int2bin(int(dctcoef[i2][i]),9) #将数f.write(hex_str + "\n ')#
# #             f. write(hex_str + ' \n')
# #定义数据
def int2bin(dec_num,bit_wide=16):
    '''十进制转为2进制数'''
    _, bin_num_abs = bin(dec_num).split('b')
    if len(bin_num_abs)  + (dec_num < 0) > bit_wide:
        raise ValueError  # 数值超出bit_wide长度所能表示的范围
    else:
        if dec_num >= 0:
            bin_num = bin_num_abs.rjust(bit_wide, '0')
        else:
            _, bin_num = bin(2 ** bit_wide + dec_num).split('b')
    return bin_num
    




if __name__ == '__main__':
    y_test1, sr_test1 = librosa.load(path="D:/PDS_FPGA/Audio_python_test/声纹识别FPGA/D 声纹识别测试音频/测试样本/1.m4a", sr=48000, offset=0.0, duration=None)
    y_test2, sr_test2 = librosa.load(path="D:/PDS_FPGA/Audio_python_test/声纹识别FPGA/D 声纹识别测试音频/测试样本/26.m4a", sr=48000, offset=0.0, duration=None)
    y_test3, sr_test3 = librosa.load(path="D:/PDS_FPGA/Audio_python_test/声纹识别FPGA/D 声纹识别测试音频/测试样本/40.m4a", sr=48000, offset=0.0, duration=None)
    y_test4, sr_test4 = librosa.load(path="D:/PDS_FPGA/Audio_python_test/声纹识别FPGA/D 声纹识别测试音频/测试样本/63.m4a", sr=48000, offset=0.0, duration=None)
    y_test1=y_test1*5000
    y_test2=y_test2*5000
    y_test3=y_test3*5000
    y_test4=y_test4*5000
    y_test12=pre_add(y_test1)
    y_test22=pre_add(y_test2)
    y_test32=pre_add(y_test3)
    y_test42=pre_add(y_test4)

    y_test1_f,nf_test1=Framing_fun(y_test12)
    y_test2_f,nf_test2=Framing_fun(y_test22)
    y_test3_f,nf_test3=Framing_fun(y_test32)
    y_test4_f,nf_test4=Framing_fun(y_test42)
    
    
    hanning_windown=np.hanning(wlen)  #调用汉明窗

    y_test1_f=y_test1_f*hanning_windown
    y_test2_f=y_test2_f*hanning_windown
    y_test3_f=y_test3_f*hanning_windown
    y_test4_f=y_test4_f*hanning_windown
   

    #阈值
    PA_TEST1,PB_TEST1=PA_PB(y_test1_f,45)
    PA_TEST2,PB_TEST2=PA_PB(y_test2_f,45)
    PA_TEST3,PB_TEST3=PA_PB(y_test3_f,45)
    PA_TEST4,PB_TEST4=PA_PB(y_test4_f,45)
    

    y_point1_test,nf_test1=point(y_test1_f,nf_test1,45,PA_TEST1,PB_TEST1)
    y_point2_test,nf_test2=point(y_test2_f,nf_test2,45,PA_TEST2,PB_TEST2)
    y_point3_test,nf_test3=point(y_test3_f,nf_test3,45,PA_TEST3,PB_TEST3)
    y_point4_test,nf_test4=point(y_test4_f,nf_test4,45,PA_TEST4,PB_TEST4)

    y_fft1_test=np.abs(np.fft.rfft(y_point1_test,1024)[:,1:])**2
    y_fft2_test=np.abs(np.fft.rfft(y_point2_test,1024)[:,1:])**2
    y_fft3_test=np.abs(np.fft.rfft(y_point3_test,1024)[:,1:])**2
    y_fft4_test=np.abs(np.fft.rfft(y_point4_test,1024)[:,1:])**2
    
    
    Y_MFCC1_DCT=MFCC_DCT(y_fft1_test,nf_test1,13)#[:,1:]
    Y_MFCC2_DCT=MFCC_DCT(y_fft2_test,nf_test2,13)#[:,1:]
    Y_MFCC3_DCT=MFCC_DCT(y_fft3_test,nf_test3,13)#[:,1:]
    Y_MFCC4_DCT=MFCC_DCT(y_fft4_test,nf_test4,13)#[:,1:]

    mfcc_feature = mfcc(y_test1, sr_test1, winlen=0.02133, winstep=0.01, nfilt=13, nfft=1024,appendEnergy=False)#[:,1:]    # mfcc系数
    

    VQ1=VQ_lbg(Y_MFCC1_DCT,nf_test1,13,16,0.03,0.00001)
    VQ2=VQ_lbg(Y_MFCC2_DCT,nf_test2,13,16,0.03,0.00001)
    VQ3=VQ_lbg(Y_MFCC3_DCT,nf_test3,13,16,0.03,0.00001)
    VQ4=VQ_lbg(Y_MFCC4_DCT,nf_test4,13,16,0.03,0.00001)
    # data_out_list=list(np.array(VQ1).flatten())
    with open( 'fff.dat', 'w') as f:
        for i2 in range(16):
            for i in range(13):
                hex_str = int2bin(int(VQ4[i2][i]),14) #将数f.write(hex_str + "\n ')#
                f. write(hex_str + ' \n')
    # VQ1_1=lbg(Y_MFCC1_DCT.T,16)
    # VQ2_1=lbg(Y_MFCC1_DCT.T,16)
    # VQ3_1=lbg(Y_MFCC1_DCT.T,16)
    # VQ4_1=lbg(Y_MFCC1_DCT.T,16)
    # print("D1_min=",D1_min)
    # print("D2_min=",D2_min)
    # print("D3_min=",D3_min)
    # print("D4_min=",D4_min)
    wav=0
    wav1=0
    while(1):
        wav=input("输入识别人语音：")
        if(wav!=wav1):
            wav1=wav
            y_train, sr_train = librosa.load(path="D:/PDS_FPGA/Audio_python_test/声纹识别FPGA/D 声纹识别测试音频/测试比对库/"+wav, sr=48000, offset=0.0, duration=None)
            y_train=y_train*5000
            y_train=pre_add(y_train)
            y_train_f,nf_train=Framing_fun(y_train)
            y_train_f=y_train_f*hanning_windown
            PA_TRAIN4,PB_TRAIN4=PA_PB(y_train_f,45)
            y_point_train,nf_train=point(y_train_f,nf_train,45,PA_TRAIN4,PB_TRAIN4)
            y_fft_train=np.abs(np.fft.rfft(y_point_train,1024)[:,1:])**2
            Y_MFCC_DCT=MFCC_DCT(y_fft_train,nf_train,13)#[:,1:]

            D1_1=np.zeros((16))
            D2_1=np.zeros((16))
            D3_1=np.zeros((16))
            D4_1=np.zeros((16))
            D1=0
            D2=0
            D3=0
            D4=0
            for i_2 in range(nf_train):
                D1_1=np.zeros((16))
                for i in range(16):
                    D1_1[i]=distance(Y_MFCC_DCT[i_2],VQ1[i])
                D1=D1+np.min(D1_1)
            for i_2 in range(nf_train):
                D2_1=np.zeros((16))
                for i in range(16):
                    D2_1[i]=distance(Y_MFCC_DCT[i_2],VQ2[i])
                D2=D2+np.min(D2_1)
            for i_2 in range(nf_train): 
                D3_1=np.zeros((16))
                for i in range(16):
                    D3_1[i]=distance(Y_MFCC_DCT[i_2],VQ3[i])
                D3=D3+np.min(D3_1)
            for i_2 in range(nf_train):
                D4_1=np.zeros((16))
                for i in range(16):
                    D4_1[i]=distance(Y_MFCC_DCT[i_2],VQ4[i])    
                D4=D4+np.min(D4_1)
            D=np.zeros((4 ))
            D_name=["D1","D2","D3","D4"]
            D[0]=D1/nf_train
            D[1]=D2/nf_train
            D[2]=D3/nf_train
            D[3]=D4/nf_train
            print("D1=",D[0])
            print("D2=",D[1])
            print("D3=",D[2])
            print("D4=",D[3])

            if(D[0]>85 and D[1]>85 and D[2]>85 and D[3]>85):#依靠经验
                print("不在库")
            else:
                print("在库")
                print("识别人:",D_name[D.argmin()])
    1
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
