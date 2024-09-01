import os, sys
import numpy as np
from scipy import signal
import librosa.display
import soundfile as sf
import matplotlib.pyplot as plt  # 导入绘图工作的函数集合
N = 1024; #STFT Frame Size
H = 512; #STFT Hop Size
L_h = 25; #Harmonic (Horizontal) Median Filter Length
L_p = 25; #Percussive (Vertical) Median Filter Length

# 分帧
wlen=1024#分帧帧长
inc =512#帧移长度
NFFT =1024

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

x, fs = librosa.load(path="D:/PDS_FPGA/Audio_python_test/人声分离/人声分离测试音频样本.m4a", mono=True, sr=48000)
# X = librosa.stft(x[60000:61024], n_fft=NFFT, hop_length=H, win_length=N, window='hamming', center=False).T 
x=(x*(pow(2,(10-1)) - 1))

x=np.rint(x)


data,nf=Framing_fun(x)
data_f=data[33]
data_f2=data[32]

data_test3=x[16384 :16896 ]
data_test2=x[15976 -2:16488 -2]
data_test5=x[16384 : ]
data5,nf5=Framing_fun(data_test5)
# fig = plt.figure('TD-PSOLA',figsize = (8,8)).add_subplot(111)
# fig.plot(data_f,color='c')
# plt.show()
hanning_windown=np.hamming(wlen)  #调用海明窗
data1=data5*hanning_windown
data2=data5*hanning_windown
np.savetxt("data2.txt",data5[0],fmt='%d')     #将数组中数据写入到data.txt文件
np.savetxt("data3.txt",data5[1],fmt='%d')     #将数组中数据写入到data.txt文件
data_w_fft=np.zeros((nf,int(wlen)),dtype=complex)

data_test=x[7169 -2:8193 -2]
Y_fft1=np.fft.fft(data_test,NFFT)
Y_fft1_real=Y_fft1.real
Y_fft1_real=Y_fft1.imag
Y_ifft1=np.fft.fft(data_test,NFFT)
# fig = plt.figure('test',figsize = (8,8)).add_subplot(111)
# fig.plot(data_test,color='c')
# plt.show()
for i in range (nf):
    # Y_fft=[0]*int(wlen/2)
    Y_fft=np.fft.fft(data1[i],NFFT)
    data_w_fft[i]=Y_fft
data_w_fft2=np.zeros((nf,int(wlen/2+1)),dtype=complex)
for i in range (nf):
    # Y_fft=[0]*int(wlen/2)
    Y_fft2=np.fft.rfft(data2[i],NFFT)
    data_w_fft2[i]=Y_fft2

x_h=np.zeros  (int(nf)*wlen)
x_p=np.zeros  (int(nf)*wlen)
# x_h_5=np.zeros(int(nf)*wlen)
x_p_5=np.zeros(int(nf)*wlen)
x_h_6=np.zeros(int(nf)*wlen)
x_p_6=np.zeros(int(nf)*wlen)
# x_h_7=np.zeros(int(nf)*wlen)
x_p_7=np.zeros(int(nf)*wlen)
S    =np.zeros((int(nf),wlen+7))
S_h  =np.zeros((int(nf),wlen))
S_p  =np.zeros((int(nf),wlen))
M_h  =np.zeros((int(nf),wlen))
X_h_1=np.zeros((int(nf),wlen))

X_p_1=np.zeros((int(nf),wlen))
x_h_5=np.zeros(wlen)
x_h_6=np.zeros(wlen)
a=np.zeros(wlen)
b=np.zeros(wlen)
p=np.zeros(wlen)
x_h_7=np.zeros(wlen)
x_h_6 =hanning_windown*hanning_windown
x_h_7[:512]=x_h_6[:512]+x_h_6[512:]
x_h_7[512:]=x_h_6[:512]+x_h_6[512:]


# np.savetxt("x_h_7.txt",x_h_7,fmt='%d')     #将数组中数据写入到data.txt文件
# x_h_7[:511]=x_h_7[:511]+hanning_windown[:511]*hanning_windown[:511]
# x_h_7[512:]=hanning_windown[512:]*hanning_windown[512:]
for i in range (7,nf):
    S[i][:wlen] = np.abs(data_w_fft[i])**2 
    # S2 = np.abs(data_w_fft2)**2 

    # S_h[i] = signal.medfilt(S[i], [1, 15]) 
    # S_p[i] = signal.medfilt(S[i], [15, 1]) 


    # for i in range(nf):
    for i_1 in range(1024):
        # a1 =S[i-7][i_1-7]
        # a2 =S[i-7][i_1-6]
        # a3 =S[i-7][i_1-5]
        a4 =S[i-7][i_1-4]
        a5 =S[i-7][i_1-3]
        a6 =S[i-7][i_1-2]
        a7 =S[i-7][i_1-1]
        a8 =S[i-7][i_1]
        a9 =S[i-7][i_1+1]
        a10=S[i-7][i_1+2]
        a11=S[i-7][i_1+3]
        a12=S[i-7][i_1+4]
        # a13=S[i-7][i_1+5]
        # a14=S[i-7][i_1+6]
        # a15=S[i-7][i_1+7]
        # p1=max(a4,a5,a6)
        # p2=np.median([a7,a8,a9])
        # p3=min(a10,a11,a12)
        # p4=np.median([p1,p2,p3])
        # p5=np.median([a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14,a15])
        S_h[i-7][i_1]=np.median([a4,a5,a6,a7,a8,a9,a10,a11,a12])
        
        # b1 =S[i-14][i_1]
        # b2 =S[i-13][i_1]
        # b3 =S[i-12][i_1]
        # b4 =S[i-11][i_1]
        # b5 =S[i-10][i_1]
        # b6 =S[i-9] [i_1]
        b7 =S[i-8] [i_1]
        b8 =S[i-7] [i_1]
        b9 =S[i-6] [i_1]
        b10=S[i-5] [i_1]
        b11=S[i-4] [i_1]
        b12=S[i-3] [i_1]
        b13=S[i-2] [i_1]
        b14=S[i-1] [i_1]
        b15=S[i][i_1]
        # p1=max(b1,b2,b3,b4,b5)
        # p2=np.median([b6,b7,b8,b9,b10])
        # p3=min(b11,b12,b13,b14,b15)
        # p4=np.median([p1,p2,p3])
        # p5=np.median([a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14,a15])
        S_p[i-7] [i_1]=np.median([b7,b8,b9,b10,b11,b12,b13,b14,b15])
    i=i-7
    # M_h = np.int8(S_h >= S_p) 
    # M_p = np.int8(S_h < S_p) 
    M_h[i] = (S_h[i] )/(S_h[i]  + S_p[i] )
    # M_p = (S_p +0.02)/(S_h +  S_p +0.4)
    # M_h = (S_h *S_h)/(S_h *S_h + S_p *S_p); 
    # M_p = (S_p *S_p)/(S_h *S_h+ S_p *S_p)
    X_h_1[i] = data_w_fft[i] * M_h[i]; 
    X_p_1[i] = data_w_fft[i] -X_h_1[i]; 

    # # X_p_1=data_w_fft-X_h_1
    # X_p_1  = S - S*M_h

    # S_h2 = signal.medfilt(X_p_1, [1, 15]) 
    # S_p2 = signal.medfilt(X_p_1, [15, 1]) 
    # M_h2 = (S_p2 )/(S_h2  + S_p2 )
    # # M_h2 = np.int8(S_h2< S_p2) 
    # X_p_2 = (data_w_fft-X_h_1) * M_h2 ; 

    p= np.fft.ifft(X_h_1[i]).real*hanning_windown

    # x_h_5 [i*inc:i*inc+wlen]= x_h_5 [i*inc:i*inc+wlen]+p
    x_h_5[:512]=b[512:]+a[:512]
    x_h_5[512:]=p[:512]+a[512:]
    b=a
    a=p
    
  



    p1= np.fft.ifft(X_h_1[i]).real*hanning_windown
    x_p_5 [i*inc:i*inc+wlen]= x_p_5 [i*inc:i*inc+wlen]+p1
    x_p_6=[0]*nf*wlen
    x_p_6 [i*inc:i*inc+wlen]=hanning_windown*hanning_windown
    x_p_7[i*inc:i*inc+wlen]=x_p_7[i*inc:i*inc+wlen]+x_p_6[i*inc:i*inc+wlen]



    x_h[i*inc:i*inc+wlen]=x_h_5/x_h_7/(pow(2,(10-1)) - 1)
    x_p[i*inc:i*inc+wlen]=x_p_5[i*inc:i*inc+wlen]/x_p_7[i*inc:i*inc+wlen]/(pow(2,(10-1)) - 1)
    i=i+7

sf.write("D:/PDS_FPGA/Audio_python_test/人声分离/HPSS_B_h8888.wav", x_h, fs)
sf.write("D:/PDS_FPGA/Audio_python_test/人声分离/_HPSS_B_p—25_2.wav", x_p, fs)

fig6 = plt.figure('TD-PSOLA',figsize = (8,8)).add_subplot(411)
fig6.plot(x/40000,color='c')
fig6 = plt.figure('TD-PSOLA',figsize = (8,8)).add_subplot(412)
fig6.plot(x/40000,color='c')
fig6.plot(x_h,color='b')
# fig6.plot(x_h[55*1024:55*1024+1024],color='c')
fig6 = plt.figure('TD-PSOLA',figsize = (8,8)).add_subplot(413)
fig6.plot(x/40000,color='c')
fig6.plot(x_p,color='b')
fig6 = plt.figure('TD-PSOLA',figsize = (8,8)).add_subplot(414)
fig6.plot(S_h[55],color='c')
fig6.plot(S_p[55],color='b')
plt.show()


