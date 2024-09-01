"""
author:WenYiXxing
Times:2024.4.30
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
# 预加重   s′(n)=s(n)－as(n－1)(a为常数)su
def pre_add(x):  # 定义预加重函数
    signal_points=len(x)  # 获取语音信号的长度
    signal_points=int(signal_points)  # 把语音信号的长度转换为整型
    y=[0]*signal_points
    for i in range(1, signal_points, 1):# 对采样数组进行for循环计算
        x[i] = x[i] - 0.94 * x[i - 1]  # 一阶FIR滤波器
    return x  # 返回预加重以后的采样数组


times = librosa.get_duration(path="D:/PDS_FPGA/Audio_python_test/变声/C 变声测试音频/变声测试音频样本男.mp3")  # 获取音频时长
y, sr = librosa.load(path="D:/PDS_FPGA/Audio_python_test/变声/C 变声测试音频/变声测试音频样本男.mp3", sr=48000, offset=0.0, duration=None)
y_w, sr_w = librosa.load(path="D:/PDS_FPGA/Audio_python_test/变声/C 变声测试音频/变声测试音频样本女.m4a", sr=48000, offset=0.0, duration=None)
# x = np.arange(0, times, 1/sr) # 时间刻度-0.0384
y=y*40000
y_w=(y_w)*40000
# fig9 = plt.figure('aaa',figsize = (10,10)).add_subplot(121)
# fig9.plot(a,color='c')
# # y=pre_add(a)
# # y_w=pre_add(y_w)

# fig9 = plt.figure('aaa',figsize = (10,10)).add_subplot(122)
# fig9.plot(a,color='c')
# fig9.plot(y,color='y')
# plt.show()

g=-0.3
def qinxie(y,g):
    signal_points=len(y)  # 获取语音信号的长度
    y2=[0]*signal_points
    signal_points=int(signal_points)  # 把语音信号的长度转换为整型
    for i in range(1, signal_points, 1):# 对采样数组进行for循环计算
        y2[i] = 1+ 2*g* y[i - 1]+g*g*y[i - 2]  # 一阶FIR滤波器
    return y2
# y=qinxie(y,g)
# y_w=qinxie(y_w,g)

# y=pre_add(y)*40000
# y_w=pre_add(y_w)*40000
# print(len(x),len(y))
print("times :\n" ,times)
print("sr :\n" ,sr)

# sf.write("y.wav",  y,sr)
# torchaudio.save(out_path, waveform, sr)
# 将字节保存到 WAV 文件
# with wave.open('y1.wav', 'wb') as wf:
#     wf.setnchannels(1)  # 音频通道（1：单声道，2：立体声）
#     wf.setsampwidth(3)  # 采样宽度（1：pyaudio.paInt8，2：pyaudio.paInt16，3：pyaudio.paInt24，4：pyaudio.paInt32）
#     wf.setframerate(48000)  # 采样率
#     wf.writeframes(b''.join(y))


#分帧
data,nf=Framing_fun(y)

data_w,nf_w=Framing_fun(y_w)

hanning_windown=np.hanning(wlen)  #调用海明窗

data_hanning=data*hanning_windown
# data_ll=[0]*300*nf
# for i_1 in range (nf):
#     for i in range (300):
#         data_ll[i_1*300-10:i_1*300+300-10]=data_hanning[i_1]/40000
# sf.write("训练音频测试/zhuanghuan_ifft6_b_0.12ww2.wav",  data_ll,sr)#读出音频
data_hanning_add=np.zeros((2*wlen-100))
data_hanning_add[:wlen]=data[189]*hanning_windown
data_hanning_add[wlen-100:2*wlen]=data[190]*hanning_windown


#基音周期
def rx(data,nf):
    RX_all=[0]*(nf)
    Rr_add=0
    RX_i=0
    for k in range(nf):
        data_time=data[k]
        RX=[0]*600  
        data_max=0
        data_min=0
        for K_1 in range(wlen):
            if (data_max>=data_time[K_1]):
                data_max=data_max
            else:
                data_max=data_time[K_1]
        for K_2 in range(wlen):
            if (data_min<=data_time[K_2]):
                data_min=data_min
            else:
                data_min=data_time[K_2]
        high=0.75*data_max+0.25*data_min
        low=0.25*data_max+0.75*data_min
        for K_3 in range(wlen):
            if(data_time[K_3]>high):
                data_time[K_3]=1
            elif(data_time[K_3]<low):
                data_time[K_3]=-1
            else:
                data_time[K_3]=0

        for K_4 in range(600):#48k 80hz-500hz 96~600
            # RX=[0]*160 
            for K_5 in range(1,wlen-K_4):
                RX[K_4]=RX[K_4]+data_time[K_5]*data_time[K_5+K_4]
        RX_max=0
        RX_max_x=0
        for K_6 in range(96,600):
            if (K_6==96):
                RX_max=RX[K_6]
                RX_max_x=K_6
            if (RX_max>=RX[K_6]):
                RX_max=RX_max
                RX_max_x=RX_max_x
            else:
                RX_max=RX[K_6]
                RX_max_x=K_6
        RX_max_RX0=RX_max/RX[0]
        Rr=0
        #判断清浊音
        if(RX_max_RX0<0.3):
            RX_all[k]=0
            Rr_add=Rr_add
            Rr=0
            RX_i=RX_i
        else:
            RX_all[k]=RX_max
            Rr=48000/RX_max_x
            Rr_add=Rr_add+Rr
            RX_i=RX_i+1
    return RX_all,Rr_add,RX_i

# RX_all,Rr_add,RX_i=rx(data,nf)
    
# RX_all_w,Rr_add_w,RX_i_w=rx(data_w,nf_w)    
    

# fig4 = plt.figure('fft',figsize = (8,8)).add_subplot(222)
# fig4.set_title('Signal')
# fig4.set_xlabel('Time (samples)')
# fig4.set_ylabel('Amplitude')
# fig4.plot(RX_all,color='b')

# # fig4 = plt.figure('fft',figsize = (8,8)).add_subplot(223)
# # fig4.set_title('Signal')
# # fig4.set_xlabel('Time (samples)')
# # fig4.set_ylabel('Amplitude')
# # fig4.plot(data_time,color='b')

# # fig4 = plt.figure('fft',figsize = (8,8)).add_subplot(224)
# # fig4.set_title('Signal')
# # fig4.set_xlabel('Time (samples)')
# # fig4.set_ylabel('Amplitude')
# # fig4.plot(RX,color='b')

# print("RX_max_add:\n",Rr_add)
# print("RX_i:\n",RX_i)
# Rr=Rr_add/RX_i
# print("Rr:\n",Rr)#195.13477741139806
# print("RX_max_add_w:\n",Rr_add_w)
# print("RX_i_w:\n",RX_i_w)
# Rr_w=Rr_add_w/RX_i_w
# print("Rr_w:\n",Rr_w)#224.91092492640516

# a=Rr_w/Rr#男变女 平均基音周期变换率

# # print("high:\n",high)
# # print("low:\n",low)
# # print("data_max:\n",data_max)
# # print("data_min:\n",data_min)

#mfcc 谱包络求解算法
# RX_all,Rr_add,RX_i=rx(data[200:400],200)
# f=Rr_add/RX_i
data7=[0]*(wlen)
for i in range(wlen):
        ranta=(math.sin(i*math.pi/(wlen)))
        data7[i]=ranta
#低通滤波器
def ditong(data,len):  # 定义预加重函数
     data2=[0]*len
     a=0.08
     for i in range(1, len, 1):
          data2[i]=(1-a)*data2[i-1]+a*data[i]
     return data2


f0_man=192#195.134
f0_woman=280
hanning_windown=np.hanning(wlen)  #调用海明窗

data_hanning_man=data*hanning_windown
data_hanning_woman=data_w*hanning_windown
# np.savetxt('test3.txt',data_hanning_man[600],fmt='%d')
zhuanghuan_ifft =[0]*(nf*1024)
zhuanghuan_ifft2=[0]*(nf*1024)
for pp in range (nf):#nf
    print("pp:",pp)
    fft_y_man=np.fft.fft(data_hanning_man[pp],NFFT) #快速傅里叶变换，取一半
    fft_y_w=np.fft.fft(data_hanning_man[pp],NFFT) #快速傅里叶变换，取一半
    fft_angle1=np.angle(fft_y_man)

    fft_real    =[0]*1024
    fft_imag    =[0]*1024
    fft_abs     =[0]*1024
    fft_angle   =[0]*1024
    fft_angle_2=[0]*1024
    for i in range (1024):
        fft_real[i]=fft_y_man[i].real
        fft_imag[i]=fft_y_man[i].imag

    for i in range (1024):
        fft_abs[i]=math.sqrt(math.pow(fft_real[i],2)+math.pow(fft_imag[i],2))
    a=np.arctan(1)
    #相位
    for i in range (0,1024):
            fft_angle[i]=np.arctan(fft_imag[i]/fft_real[i])
            fft_angle_2[i]=np.arctan(fft_imag[i]/fft_real[i])
    fft_angle3=np.angle(fft_y_man)

    #2pi解卷绕
    for i in range (1,1024):
        # for i_1 in range (8):
            chazhi=fft_angle3[i]-fft_angle3[i-1]
            if(chazhi>math.pi):
                for i_2 in range(i,1024):
                    fft_angle3[i_2]=fft_angle3[i_2]-math.pi*2
            if(chazhi<-math.pi):
                for i_2 in range(i,1024):
                    fft_angle3[i_2]=fft_angle3[i_2]+math.pi*2
    # for i in range (50,1024,50):
    #     for i_1 in range (8-1):
    #         chazhi=fft_angle_2[i+i_1+1]-fft_angle_2[i+i_1]
    #         if(chazhi>math.pi/2):
    #             for i_2 in range(8-(i_1+1)):
    #                 fft_angle_2[i+i_1+1+i_2]=fft_angle_2[i+i_1+1+i_2]-math.pi
    #         if(chazhi<-math.pi/2):
    #             for i_2 in range(8-(i_1+1)):
    #                 fft_angle_2[i+i_1+1+i_2]=fft_angle_2[i+i_1+1+i_2]+math.pi
    #分段相位
    # fft_angle_a=fft_angle_2[50+8-1]/fft_angle_2[50]
    # fft_angle_b=50
    # for i in range (50,1024,50):
    #     chazhi=0
    #     chazhi_1=0
    #     m=0
    #     for i_1 in range (8-1):
    #         fft_angle_2[i+i_1]=fft_angle_2[i+i_1]+math.pi*m
    #         chazhi=fft_angle_a*(i+i_1-50)+50-fft_angle_2[i+i_1]
    #         if(chazhi>chazhi_1):
    #             m=m+1
    #         if(chazhi>chazhi_1):
    #             m=m+1
    #         else :
    #             m=m

    #2pi解卷绕
    a=math.cos(2.09433)
    #恢复波形
    fft_huifu=[0]*1024
    cos=[0]*1024
    sin=[0]*1024
    for i in range (1024):
        cos[i]=math.cos(fft_angle3[i])
        sin[i]=math.sin(fft_angle3[i])
        fft_huifu[i]=complex( fft_abs[i]*math.cos(fft_angle3[i]) ,fft_abs[i]*math.sin(fft_angle3[i]))

    abs_y_man=np.abs(fft_y_man)
    # abs_y_man[0]=abs_y_man[0]/2

    abs_y_man_1=abs_y_man
    db_man=20* np.log10(fft_abs)
    db_w=20* np.log10(fft_abs)
    # xk_change_db=[0]*512
    # for i in range(0,512):
    #         xk_change_db[i]=math.pow(10,db_man[i]/20)

    ifft_y_man=np.fft.ifft(fft_y_man)
    # ifft_y_man=np.fft.ifft(abs_y_man_1)

    fft_f_i=[0]*(1025)
    fft_f=48000/NFFT
    for i in range(1025):
        fft_f_i[i]=i*fft_f

    def db_baolao(db,f0):
        db_max_all=[0]*48000
        fft_f=48000/NFFT
        db_max_i_2=0
        for db_max_i in range(124*2):
            db_f_min=(db_max_i*f0 - f0/2)
            db_f_max=(db_max_i*f0 + f0/2)
            if(db_f_max>48000):
                db_f_max=48000
            if(db_f_min<0):
                db_f_min=0
            # db_f_max=db_f_max/fft_f
            # db_f_min=db_f_min/fft_f
            for db_max_i_1 in range(int(db_f_min),int(db_f_max-1)):#（IF0 - F0 / 2 < fI < IF0 + F0 / 2），寻找最大值
                if (db_max_i_1 == int(db_f_min)):
                    db_max = db[int(db_max_i_1/fft_f)]
                    db_max_i_l=int(db_max_i_1)
                if (db_max >= db[int(db_max_i_1/fft_f)]):
                    db_max = db_max
                    db_max_i_l=db_max_i_l
                else:
                    db_max = db[int(db_max_i_1/fft_f)]
                    db_max_i_l=int(db_max_i_1)
            db_max_all[db_max_i_l]=db_max

            k=(db_max_all[db_max_i_l]-db_max_all[db_max_i_2])/(db_max_i_l-db_max_i_2)
            for x in range(db_max_i_2,db_max_i_l):
                db_max_all[x]=db_max_all[db_max_i_2]+k*(x-db_max_i_2)

            db_max_i_2=db_max_i_l

        return db_max_all
    # 得阶梯谱包络 S1
    db_baolao_man=db_baolao(db_man,f0_man)
    db_baolao_w  =db_baolao(db_w,f0_woman)
    db_baolao_man_1=[0]*1024
    db_baolao_w_1=[0]*1024
    for i in range (1024):
        db_baolao_man_1[i]=db_baolao_man[int(fft_f_i[i])]   
    for i in range (1024):
        db_baolao_w_1[i]=db_baolao_w[int(fft_f_i[i])]   
    # Mel 尺度的包络函数 S2
    mfcc_mel_max=1127*math.log((1+48000/700),math.e)
    mfcc_mel_max=int(mfcc_mel_max)
    mfcc_mel=[0]*mfcc_mel_max
    for mfcc_hz_mel_i in range (0,mfcc_mel_max,4):#枚4mel进行一次mei——》hz
        mfcc_mel_hz=int(700*(math.pow(math.e,mfcc_hz_mel_i/1127)-1))
        mfcc_mel[mfcc_hz_mel_i]=db_baolao_man[mfcc_mel_hz]
    #阶梯
        k=(mfcc_mel[mfcc_hz_mel_i]-mfcc_mel[mfcc_hz_mel_i-4])/4
        for x in range(mfcc_hz_mel_i-4,mfcc_hz_mel_i):
            mfcc_mel[x]=mfcc_mel[mfcc_hz_mel_i-4]+k*(x-mfcc_hz_mel_i+4)


    # mfcc_hz=[0]*48000
    # for mfcc_hz_mel_i in range (48000-40):
    #     mfcc_mel_hz=int(1127*math.log((1+mfcc_hz_mel_i/700),math.e))
    #     mfcc_hz[mfcc_hz_mel_i]=mfcc_mel[mfcc_mel_hz]

    #MFCC 150系数。一维DCT计算
    c=[0]*20
    for n in range (20):
        c_all=0
        for m in range(mfcc_mel_max):
            c_all=c_all+mfcc_mel[m]*math.cos((math.pi*m*n)/(mfcc_mel_max))
        c[n]=c_all/mfcc_mel_max

    # y2 = dct(mfcc_mel)

    #MFCC谱包络 mel
    MFCC_baolao=[0]*mfcc_mel_max
    for m in range(mfcc_mel_max):
        MFCC_baolao_all=0
        for n in range(1,20):
            MFCC_baolao_all=MFCC_baolao_all+c[n]*math.cos((math.pi*m*n)/(mfcc_mel_max))
        MFCC_baolao[m]=c[0]+2*MFCC_baolao_all
   

    MFCC_baolao_hz=[0]*48001
    for mfcc_hz_mel_i in range (48000-10):
        mfcc_mel_hz=int(1127*math.log((1+mfcc_hz_mel_i/700),math.e))
        MFCC_baolao_hz[mfcc_hz_mel_i]=MFCC_baolao[mfcc_mel_hz]
    #转为513个点
    MFCC_baolao_hz_1=[0]*1024
    for i in range(1024):
        MFCC_baolao_hz_1[i]=MFCC_baolao_hz[int(fft_f_i[i])]


     # 弯折函数插值求弯折后倒谱谱包络
    b=0.1#频谱弯折参数值
    w=[0]*512
    k2=[0]*512
    w1=[0]*512
    for k in range (512):
        w1[k]=k*math.pi/512
    for k in range (512):
        w[k]=np.arctan(  ((1-b*b)*math.sin(w1[k]))  /  ((1+b*b)*math.cos(w1[k])+2*b)  )
    #2pi解卷绕
    for i in range (1,512):
            chazhi=w[i]-w[i-1]
            if(chazhi>=3):
                for i_2 in range(i,512):
                    w[i_2]=w[i_2]-math.pi
            if(chazhi<=-3):
                for i_2 in range(i,512):
                    w[i_2]=w[i_2]+math.pi
    #离散化
    for i in range (512):
        k2[i]=512*w[i]/math.pi
    s_MFCC_baolao=[0]*512
    s_MFCC_baolao_1014=[0]*1024#进行频谱弯折后的谱包络
    #进行频谱弯折后的谱包络   
    for i in range (512):
        s_MFCC_baolao[i]=MFCC_baolao_hz_1[ int(k2[i]) ]* ( int(k2[i])+1-k2[i]  ) + MFCC_baolao_hz_1 [ int(k2[i]) + 1]* (k2[i]- int(k2[i]))
    for i in range (1024):
        if(i<512):
             s_MFCC_baolao_1014[i]=s_MFCC_baolao[i]
        else:
             s_MFCC_baolao_1014[i]=s_MFCC_baolao[1023-i]


    # fig9 = plt.figure('aaa',figsize = (10,10)).add_subplot(221)
    # fig9.set_title('y_w')
    # fig9.set_xlabel('Time (samples)')
    # fig9.set_ylabel('Amplitude')
    # fig9.plot(w,color='c')
    # fig9 = plt.figure('aaa',figsize = (10,10)).add_subplot(222)
    # fig9.set_title('y_w')
    # fig9.set_xlabel('Time (samples)')
    # fig9.set_ylabel('Amplitude')
    # fig9.plot(k2,color='c')
    # fig9 = plt.figure('aaa',figsize = (10,10)).add_subplot(223)
    # fig9.set_title('y_w')
    # fig9.set_xlabel('Time (samples)')
    # fig9.set_ylabel('Amplitude')
    # fig9.plot(MFCC_baolao_hz_1,color='c')
    # fig9.plot(s_MFCC_baolao_1014,color='y')
    # fig9 = plt.figure('aaa',figsize = (10,10)).add_subplot(224)
    # fig9.set_title('s_MFCC_baolao')
    # fig9.set_xlabel('Time (samples)')
    # fig9.set_ylabel('Amplitude')
    # fig9.plot(s_MFCC_baolao_1014,color='c')
    # plt.show()




    #TD-PSOLA

    #激励谱
    xk=[0]*1024
    for i in range(1024):
        xk[i]=db_man[i]-db_baolao_man_1[i]


    # 通过频率轴的压缩一 扩展来实现基音频率的改变 相位也要对应
    a_man_to_w=f0_man/f0_woman
    yk=[0]*512
    fft_angle3_1=[0]*512
    for k in range(512):
        if(k==478):
            l=1
        ks=int (k*a_man_to_w)
        n=k*a_man_to_w-ks
        if(ks>=511 and ks<1022 ):
            yk[k]=yk[ks-511]
            fft_angle3_1[k]=fft_angle3_1[ks-511]
        elif(ks>=1022 and ks<1533):
            yk[k]=yk[ks-1022]
            fft_angle3_1[k]=fft_angle3_1[ks-1022]
        elif(ks>=1533 and ks<2044):
            yk[k]=yk[ks-1533]
            fft_angle3_1[k]=fft_angle3_1[ks-1533]
        elif(ks>=2044 and ks <2555):
            yk[k]=yk[ks-2044]
            fft_angle3_1[k]=fft_angle3_1[ks-2044]
        elif(ks>=2555  and ks<3066):
            yk[k]=yk[ks-2555]
            fft_angle3_1[k]=fft_angle3_1[ks-2555]
        elif(ks>=3066  and ks<3577):
            yk[k]=yk[ks-3066]
            fft_angle3_1[k]=fft_angle3_1[ks-3066]
        elif(ks>=3577  and ks<4088):
            yk[k]=yk[ks-3577]
            fft_angle3_1[k]=fft_angle3_1[ks-3577]
        else:
            yk[k]= n*xk[ks]+(1-n)*xk[ks+1]
            fft_angle3_1[k]=n*fft_angle3[ks]+(1-n)*fft_angle3[ks+1]




    #基频变换后 的幅度谱
    xk_change=[0]*512
    for i in range(512):
        xk_change[i]=yk[i]+s_MFCC_baolao[i]
    #复制对称
    xk_change_db=[0]*1024
    fft_angle3_2=[0]*1024
    for i in range(0,1024):
        if(i<512):
            xk_change_db[i]=xk_change[i]
            fft_angle3_2[i]=fft_angle3_1[i]
        else:
            xk_change_db[i]=xk_change[1023-i]
            fft_angle3_2[i]=fft_angle3_1[1023-i]
    #db->bds
    xk_bas=[0]*1024
    for i in range(0,1024):#20* np.log10(abs_y_man)
        xk_bas[i]=math.pow(10,(xk_change_db[i])/20)

    #语音转换完成恢复波形
    fft_zhuanghuan=[0]*1024
    cos=[0]*1024
    sin=[0]*1024
    for i in range (1024):
        cos[i]=math.cos(fft_angle3_2[i])
        sin[i]=math.sin(fft_angle3_2[i])
        fft_zhuanghuan[i]=complex( xk_bas[i]*math.cos(fft_angle3_2[i]) ,xk_bas[i]*math.sin(fft_angle3_2[i]))
    zhuanghuan_ifft[pp*inc:pp*inc+inc]=(np.fft.ifft(fft_zhuanghuan).real/40000)
    zhuanghuan_ifft2[pp*1024:pp*1024+1024]=np.fft.ifft(fft_zhuanghuan).real/40000
    
    # zhuanghuan_ifft3=[0]*(wlen-inc)
    # zhuanghuan_ifft4=[0]*(wlen-inc)
    # zhuanghuan_chongdie=[0]*(wlen-inc)
    # zhuanghuan_ifft3=zhuanghuan_ifft2[pp*1024:pp*1024+(wlen-inc)]
    # zhuanghuan_ifft4=zhuanghuan_ifft2[(pp-1)*1024+inc:(pp-1)*1024+1024]
    # # zhuanghuan_chongdie=zhuanghuan_ifft[pp*1024-(wlen-inc):pp*1024]\
    # for i in range(wlen-inc):
    #     # ranta=(1+math.cos(i*math.pi/(wlen-inc))/2)
    #     # data
    #     zhuanghuan_chongdie[i]=data7[i]*zhuanghuan_ifft4[i]
    # zhuanghuan_chongdie=ditong(zhuanghuan_chongdie,wlen-inc)
    # zhuanghuan_ifft[pp*inc:pp*inc+(wlen-inc)]=zhuanghuan_chongdie[:wlen-inc]
    
x_h=np.zeros  (nf*wlen)
x_p=np.zeros  (nf*wlen )
x_h_5=np.zeros(nf*wlen)
x_p_5=np.zeros(nf*wlen)
x_h_6=np.zeros(nf*wlen)
x_p_6=np.zeros(nf*wlen)
x_h_7=np.zeros(nf*wlen)
x_p_7=np.zeros(nf*wlen)
for i in range (nf):
    p= zhuanghuan_ifft2[i*1024:i*1024+wlen]*hanning_windown
    x_h_5 [i*inc:i*inc+wlen]= x_h_5 [i*inc:i*inc+wlen]+p
    x_h_6=[0]*nf*wlen
    x_h_6 [i*inc:i*inc+wlen]=hanning_windown*hanning_windown
    x_h_7[i*inc:i*inc+wlen]=x_h_7[i*inc:i*inc+wlen]+x_h_6[i*inc:i*inc+wlen]
# x_h_7[x_h_7 == 0] = np.finfo(np.float32).eps
x_h=x_h_5/x_h_7

# zhuanghuan_ifft=qinxie(zhuanghuan_ifft,g)
# y_w=qinxie(y_w,g)
# for i in range (200):
#     for i_1 in range (1024):
#          zhuanghuan_ifft[i:i_1]=zhuanghuan_ifft[i:i_1]/40000
sf.write("D:/PDS_FPGA/Audio_python_test/变声/训练音频测试/男-女.wav",  x_h,sr)#读出音频
# ifft=np.fft.ifft(xk_change_db)

fig5 = plt.figure('mfcc 谱包络求解算法',figsize = (9,9)).add_subplot(331)
fig5.set_title('man')
fig5.set_xlabel('Time (samples)')
fig5.set_ylabel('Amplitude')
fig5.plot(data_hanning_man[100],color='b')

fig5 = plt.figure('mfcc 谱包络求解算法',figsize = (9,9)).add_subplot(332)
fig5.set_title('fft_y_man')
# fig5.set_xlabel('Time (samples)')
# fig5.set_ylabel('Amplitude')
# fig5.plot(fft_f_i,db_man,color='b')
# fig5.plot(db_baolao_man,color='c')
fig5.plot(fft_y_man,color='k')
# fig5.plot(MFCC_baolao_hz,color='y')

fig5 = plt.figure('mfcc 谱包络求解算法',figsize = (9,9)).add_subplot(333)
fig5.set_title('fft_angle')
# fig5.set_xlabel('Time (samples)')
# fig5.set_ylabel('Amplitude')
fig5.plot(fft_angle,color='b')
fig5.plot(fft_angle3,color='y')
fig5.plot(fft_angle3_2,color='r')

fig5 = plt.figure('mfcc 谱包络求解算法',figsize = (9,9)).add_subplot(334)
fig5.set_title('fft_angle_1')
# fig5.set_xlabel('Time (samples)')
# fig5.set_ylabel('Amplitude')
fig5.plot(fft_angle_2,color='b')

fig5 = plt.figure('mfcc 谱包络求解算法',figsize = (9,9)).add_subplot(335)
fig5.set_title('fft_huifu')
# fig5.set_xlabel('Time (samples)')
# fig5.set_ylabel('Amplitude')
fig5.plot(fft_huifu,color='c')
# fig5.plot(MFCC_baolao_hz,color='y')

# fig5 = plt.figure('mfcc 谱包络求解算法',figsize = (9,9)).add_subplot(336)
# fig5.set_title('fft_huifu_ifft')
# # fig5.set_xlabel('Time (samples)')
# # fig5.set_ylabel('Amplitude')
# fig5.plot(fft_huifu_ifft,color='c')

fig5 = plt.figure('mfcc 谱包络求解算法',figsize = (9,9)).add_subplot(337)
fig5.set_title('data_hanning_man[600]')
fig5.set_xlabel('Time (samples)')
fig5.set_ylabel('Amplitude')
fig5.plot(data_hanning_man[100],color='c')

# fig5 = plt.figure('mfcc 谱包络求解算法',figsize = (9,9)).add_subplot(338)
# fig5.set_title('fft_huifu_ifft2')
# fig5.set_xlabel('Time (samples)')
# fig5.set_ylabel('Amplitude')
# fig5.plot(fft_huifu_ifft2,color='c')

fig5 = plt.figure('mfcc 谱包络求解算法',figsize = (9,9)).add_subplot(339)
fig5.set_title('fft_angle')
fig5.set_xlabel('Time (samples)')
fig5.set_ylabel('Amplitude')
fig5.plot(fft_angle,color='c')
fig5.plot(db_man,color='b')

#TD-PSOLA 

fig6 = plt.figure('TD-PSOLA',figsize = (11,11)).add_subplot(441)
fig6.set_title('data_hanning_man[200]')
fig6.plot(data_hanning_man[200],color='c')

fig6 = plt.figure('TD-PSOLA',figsize = (11,11)).add_subplot(442)
fig6.set_title('db_man')
fig6.plot(db_man,color='c')
fig6.plot(MFCC_baolao_hz_1,color='y')
fig6.plot(db_baolao_man_1,color='b')

fig6 = plt.figure('TD-PSOLA',figsize = (11,11)).add_subplot(443)
fig6.set_title('MFCC_baolao_hz_1')
fig6.plot(MFCC_baolao_hz_1,color='c')
fig6.plot(db_baolao_man_1,color='y')

fig6 = plt.figure('TD-PSOLA',figsize = (11,11)).add_subplot(444)
fig6.set_title('xk')
fig6.plot(xk,color='c')

fig6 = plt.figure('TD-PSOLA',figsize = (11,11)).add_subplot(445)
fig6.set_title('yk')
fig6.plot(yk,color='c')

fig6 = plt.figure('TD-PSOLA',figsize = (11,11)).add_subplot(446)
fig6.set_title('xk_change')
fig6.plot(xk_change,color='c')

fig6 = plt.figure('TD-PSOLA',figsize = (11,11)).add_subplot(447)
fig6.set_title('xk_change_db')
fig6.plot(xk_change_db,color='c')

fig6 = plt.figure('TD-PSOLA',figsize = (11,11)).add_subplot(448)
fig6.set_title('xk_bas')
fig6.plot(xk_bas,color='c')

fig6 = plt.figure('TD-PSOLA',figsize = (11,11)).add_subplot(449)
fig6.set_title('zhuanghuan_ifft[200*1024:200*1024+1024]')
fig6.plot(zhuanghuan_ifft[201*inc:201*inc+inc],color='c')
# fig6.plot(zhuanghuan_ifft,color='y')

fig6 = plt.figure('TD-PSOLA',figsize = (11,11)).add_subplot(4,4,12)
fig6.set_title('zhuanghuan_ifft[200*1024:200*1024+1024]')
fig6.plot(zhuanghuan_ifft[200*inc:200*inc+inc],color='c')
# fig6.plot(zhuanghuan_ifft,color='y')
fig6 = plt.figure('TD-PSOLA',figsize = (11,11)).add_subplot(4,4,13)
fig6.plot(zhuanghuan_ifft[200*inc:201*inc+inc],color='c')
# fig6.plot(zhuanghuan_ifft,color='y')

fig6 = plt.figure('TD-PSOLA',figsize = (11,11)).add_subplot(4,4,10)
fig6.set_title('y')
fig6.plot(y,color='c')

fig6 = plt.figure('TD-PSOLA',figsize = (11,11)).add_subplot(4,4,11)
fig6.set_title('y')
fig6.set_xlabel('Time (samples)')
fig6.set_ylabel('Amplitude')
fig6.plot(y,color='c')

fig7 = plt.figure('声音转换',figsize = (10,10)).add_subplot(121)
fig7.set_title('zhuanghuan_ifft')
fig7.set_xlabel('Time (samples)')
fig7.set_ylabel('Amplitude')
fig7.plot(zhuanghuan_ifft,color='c')
# fig6.plot(zhuanghuan_ifft,color='y')

fig7 = plt.figure('声音转换',figsize = (10,10)).add_subplot(122)
fig7.set_title('y')
fig7.set_xlabel('Time (samples)')
fig7.set_ylabel('Amplitude')
fig7.plot(zhuanghuan_ifft2,color='c')
# fig6 = plt.figure('TD-PSOLA',figsize = (10,10)).add_subplot(4410)
# fig6.set_title('zhuanghuan_ifft')
# fig6.set_xlabel('Time (samples)')
# fig6.set_ylabel('Amplitude')
# fig6.plot(zhuanghuan_ifft,color='c')

fft_in=[0]*1024
   

# data_array=np.loadtxt('test.txt',delimiter=' ')#默认float
# for i in range (1024):
#     fft_in[i]=data_array[i]
# fft=np.fft.fft(fft_in,1024) 
# fig6 = plt.figure('TD-PSOLA',figsize = (9,9)).add_subplot(336)
# fig6.set_title('ifft')
# fig6.set_xlabel('Time (samples)')
# fig6.set_ylabel('Amplitude')
# fig6.plot(fft,color='c')

plt.show()