import numpy as np
import matplotlib.pyplot as plt  # 导入绘图工作的函数集合
# from pydub import AudioSegment
import librosa.display  # 导入音频及绘图显示
import math
from scipy.fftpack import dct, idct
from scipy.io import wavfile
import soundfile as sf
import wave
import python_speech_features
from python_speech_features import mfcc 
# from dtw import dtw
import pandas as pd
import xlwt
# import torchaudio
# 分帧
wlen=1024#分帧帧长
inc =500#帧移长度
inc2 =1024#帧移长度
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
def Framing_fun2(data):
    signal_len=len(data)# 获取语音信号的长度
    if signal_len<=wlen: 
        nf=1
    else:                
        nf=int(np.ceil((1.0*signal_len-wlen+inc2)/inc2))
    pad_len=int((nf-1)*inc2+wlen) 
    zeros=np.zeros((pad_len-signal_len,))#补0
    pad_data=np.concatenate((data,zeros)) 
    indices=np.tile(np.arange(0,wlen),(nf,1))+np.tile(np.arange(0,nf*inc2,inc2),(wlen,1)).T  #相当于对所有帧的时间点进行抽取，得到nf*wlen长度的矩阵
    indices=np.array(indices,dtype=np.int32) #将indices转化为矩阵
    frames=pad_data[indices] #得到帧信号
    return frames,nf
# 预加重   s′(n)=s(n)－as(n－1)(a为常数)su
def pre_add(x):  # 定义预加重函数
    signal_points=len(x)  # 获取语音信号的长度
    signal_points=int(signal_points)  # 把语音信号的长度转换为整型
    for i in range(1, signal_points, 1):# 对采样数组进行for循环计算
        x[i] = x[i] - 0.9175 * x[i - 1]  # 一阶FIR滤波器
    return x  # 返回预加重以后的采样数组
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
def mfcc_baolao(db_baolao,fft_f_i):
    # Mel 尺度的包络函数 S2
    mfcc_mel_max=1127*math.log((1+48000/700),math.e)
    mfcc_mel_max=int(mfcc_mel_max)
    mfcc_mel=[0]*mfcc_mel_max
    for mfcc_hz_mel_i in range (0,mfcc_mel_max,4):#枚4mel进行一次mei——》hz
        mfcc_mel_hz=int(700*(math.pow(math.e,mfcc_hz_mel_i/1127)-1))
        mfcc_mel[mfcc_hz_mel_i]=db_baolao[mfcc_mel_hz]
    #阶梯
        k=(mfcc_mel[mfcc_hz_mel_i]-mfcc_mel[mfcc_hz_mel_i-4])/4
        for x in range(mfcc_hz_mel_i-4,mfcc_hz_mel_i):
            mfcc_mel[x]=mfcc_mel[mfcc_hz_mel_i-4]+k*(x-mfcc_hz_mel_i+4)
    #MFCC 150系数。一维DCT计算
    c=[0]*150
    for n in range (150):
        c_all=0
        for m in range(mfcc_mel_max):
            c_all=c_all+mfcc_mel[m]*math.cos((math.pi*m*n)/(mfcc_mel_max))
        c[n]=c_all/mfcc_mel_max
    #MFCC谱包络 mel
    MFCC_baolao=[0]*mfcc_mel_max
    for m in range(mfcc_mel_max):
        MFCC_baolao_all=0
        for n in range(1,150):
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
    return MFCC_baolao_hz_1
def baoliu(data2,nf2,db):
    energy = [0]*nf2
    for i in range (nf2):
        sum=0
        for i_1 in range (1024):
            sum=sum+data2[i][i_1]*data2[i][i_1]
        energy[i]=sum/1e10
    sum1=0
    sum2=0
    for i in range (nf2):
        if(energy[i]>=db):
            sum1=sum1+1
    data_q = [0]*(1024*sum1)
    for i in range (nf2):
        if(energy[i]>=db):
            data_q[sum2*1024:sum2*1024+1024]=data2[i]
            sum2=sum2+1
    for i in range (len(data_q)):
        data_q[i]=data_q[i]
    return data_q,energy

y, sr = librosa.load(path="D:/PDS_FPGA/Audio_python_test/C 变声测试音频/变声测试音频样本男.mp3", sr=48000, offset=0.0, duration=None)
y_w, sr_w = librosa.load(path="D:/PDS_FPGA/Audio_python_test/C 变声测试音频/变声测试音频样本女.m4a", sr=48000, offset=0.0, duration=None)
y=pre_add(y)*40000
y_w=pre_add(y_w)*40000
#分帧
data3,nf3=Framing_fun(y)
data_w3,nf_w3=Framing_fun(y_w)

hanning_windown=np.hanning(wlen)  #调用汉明窗
for i in range(nf3):
    data3[i]=data3[i]*hanning_windown
for i in range(nf_w3):
    data_w3[i]=data_w3[i]*hanning_windown

g=-0.3
signal_points=len(y)  # 获取语音信号的长度
y2=[0]*signal_points
signal_points=int(signal_points)  # 把语音信号的长度转换为整型
for i in range(1, signal_points, 1):# 对采样数组进行for循环计算
    y2[i] = 1+ 2*g* y[i - 1]+g*g*y[i - 2]  # 一阶FIR滤波器
data3_1,nf3_1=Framing_fun(y2)
for i in range(nf3_1):
    data3_1[i]=data3_1[i]*hanning_windown


data2,nf2=Framing_fun2(y)
data_w2,nf_w2=Framing_fun2(y_w)
# ############只保留男声音

data_q,energy1=baoliu(data2,nf2,0.005)
# # sf.write("训练音频测试/过滤男.wav",  data_q,sr)#读出音频     
# ############只保留男声音

# ############只保留女声音
data_qnv,energy2=baoliu(data_w2,nf_w2,0.03)
# # sf.write("训练音频测试/过滤女.wav",  data_qnv,sr)#读出音频     
# ############只保留女声音



data_q_1 = np.pad(data_q,(0,len(y)-len(data_q)),'constant',constant_values=(0,0))
data_qnv_1 = np.pad(data_qnv,(0,len(y_w)-len(data_qnv)),'constant',constant_values=(0,0))
data,nf=Framing_fun(data_q_1)
data_w,nf_w=Framing_fun(data_qnv_1)
mfcc_m = mfcc(y, sr, winlen=wlen/sr, winstep=inc/sr, nfilt=13, nfft=1024)  # mfcc系数
mfcc_w = mfcc(y_w, sr, winlen=wlen/sr, winstep=inc/sr, nfilt=13, nfft=1024)  # mfcc系数
    #其中wavedata为语音数据
    #framerate为采样率
    #winlen为帧长，单位为秒
    #winstep为帧移，单位为秒
    #nfilt为返回的mfcc数据维数，默认为13维（但经过我的实验，nfilt最多也只能返回13维的mfcc参数）
    #nfft为fft点数，一般要和帧长对应的采样点数要一样
    # imfccs = imfcc(sig, 13)
    # mfes   = mfe(sig, fs)
where_are_nan = np.isnan(mfcc_m)
where_are_inf = np.isinf(mfcc_m)
#nan替换成0,inf替换成nan
mfcc_m[where_are_nan] = 0
mfcc_m[where_are_inf] = 0
where_are_nan = np.isnan(mfcc_w)
where_are_inf = np.isinf(mfcc_w)
#nan替换成0,inf替换成nan
mfcc_w[where_are_nan] = 0
mfcc_w[where_are_inf] = 0

mfcc_m_abs=np.abs(mfcc_m)
db_m=20* np.log10(mfcc_m_abs)
mfcc_w_abs=np.abs(mfcc_w)
db_w=20* np.log10(mfcc_w_abs)

num_ceps=12
c_m = dct(db_m, type=2, axis=-1, norm='ortho')
c_w = dct(db_w, type=2, axis=-1, norm='ortho')



where_are_nan = np.isnan(c_m)
where_are_inf = np.isinf(c_m)
#nan替换成0,inf替换成nan
c_m[where_are_nan] = 0
c_m[where_are_inf] = 0
where_are_nan = np.isnan(c_w)
where_are_inf = np.isinf(c_w)
#nan替换成0,inf替换成nan
c_w[where_are_nan] = 0
c_w[where_are_inf] = 0

c_m_1=np.delete(c_m,[0],axis=1) #二维数组删除0+1、1+1列
c_w_1=np.delete(c_w,[0],axis=1) #二维数组删除0+1、1+1列
fig1 = plt.figure('原波',figsize = (10,10)).add_subplot(221)
fig1.set_title('y')
fig1.set_xlabel('Time (samples)')
fig1.set_ylabel('Amplitude')
fig1.plot(y,color='c')
fig1 = plt.figure('原波',figsize = (10,10)).add_subplot(222)
fig1.plot(data_q,color='c')
fig1 = plt.figure('原波',figsize = (10,10)).add_subplot(223)
fig1.plot(y_w,color='c')
fig1 = plt.figure('原波',figsize = (10,10)).add_subplot(224)
fig1.plot(data_qnv,color='c')
# fig2 = plt.figure('原波2',figsize = (10,10)).add_subplot(221)
# fig2.plot(d_mfcc_feat_m_1,color='c')
# fig2 = plt.figure('原波2',figsize = (10,10)).add_subplot(222)
# fig2.plot(d_mfcc_feat_w_1,color='c')
# plt.show()

# #数据对齐

#欧式距离
def distance(data1,data2,n):
    sum=0
    # for i in range (n):
    #     sum=sum+math.pow((data1[i]-data2[i]),2)
    # d=math.sqrt(sum)
    for i in range (n):
        sum=sum+np.abs((data1[i]-data2[i]))
    d=sum
    return d

def dtw2(data_m,data_w):
    m = data_m.shape[0]
    n = data_w.shape[0]
    db=np.zeros((m,n))#构建二维数组
    for i_m in range(m):
        for i_n in range(n):
            db[i_m][i_n]=distance(data_m[i_m] , data_w[i_n],data_m.shape[1])
    # 路径回溯
    
    i = 0
    j = 0
    d = np.zeros(max(m,n)*3)
    count =0
    path = []
    while 1:
        if i<m-2 and j<n-2:
            path.append((i,j))
            db_you = db[i+1][j+2]
            db_xia = db[i+2][j+1]
            db_xie = db[i+1][j+1]
            if db_you<db_xia and db_you<db_xie:
                db_min=db_you
            elif db_xia<db_you and db_xia<db_xie:
                db_min=db_xia
            elif db_xie<=db_you and db_xie<=db_xia:
                db_min=db_xie

            if db_min == db_you:
                d[count] = d[count] + db[i][j+1]
                j = j+2
                i= i+1
                count = count+1
            elif db_min == db_xia:
                d[count] = d[count] + db[i+2][j+1]
                i = i+2
                j = j+1
                count = count+1
            elif db_min == db_xie:
                d[count] = d[count] + db[i+1,j+1]
                i = i+1
                j = j+1
                count = count+1
        elif i == m-2 and j == n-2:
            path.append((i,j))
            d[count] = d[count]
            count = count+1
            break

        elif i == m-2:
            path.append((i,j))
            d[count] = d[count] + db[i+1][j]
            j = j+1
            count = count+1
        
        elif j == n-2:
            path.append((i,j))
            d[count] = d[count] + db[i+1][j]
            i = i+1
            count = count+1

    mean = np.sum(d) / count
    return mean, path,db

mean, path,db=dtw2(c_m_1,c_w_1)

len2=len(path)
data_path1=[0]*len2*1024
# data_path1=y/40000
data_path2=[0]*len2*1024
for i in range (len2):
    data_path1[i*1024-500:i*1024+1024]=data3[path[i][0]]
    data_path2[i*1024-500:i*1024+1024]=data_w3[path[i][1]]

#分帧
data_dtw_m,nf_dtw_m=Framing_fun(data_path1)
data_dtw_w,nf_dtw_w=Framing_fun(data_path2)
data_dtw_m_qnv,energy_m =baoliu(data_dtw_m,nf_dtw_m,0.0006)
data_dtw_w_qnv,energy2_w=baoliu(data_dtw_w,nf_dtw_w,0.017)
data_dtw_m1,nf_dtw_m1=Framing_fun(data_dtw_m_qnv)
data_dtw_w1,nf_dtw_w1=Framing_fun(data_dtw_w_qnv)
#加窗
hanning_windown=np.hanning(wlen)  #调用海明窗
data__dtw_m_hanning=data_dtw_m1*hanning_windown
data__dtw_w_hanning=data_dtw_w1*hanning_windown
#
pp=90#第几帧
fft_y_man=np.fft.fft(data3[200],NFFT) #快速傅里叶变换，取一半
fft_y_w  =np.fft.fft(data3_1[200],NFFT) #快速傅里叶变换，取一半
# fft_y_man=np.fft.fft(data3[path[200][0]],NFFT) #快速傅里叶变换，取一半
# fft_y_w  =np.fft.fft(data_w3[path[200][1]],NFFT) #快速傅里叶变换，取一半
abs_y_man=np.abs(fft_y_man)
abs_y_w  =np.abs(fft_y_w  )
db_man   =20* np.log10(abs_y_man)
db_w     =20* np.log10(abs_y_w  )
#阶梯包咯
f0_man=195.134
f0_woman=280.91
db_baolao_man=db_baolao(db_man,f0_man)
db_baolao_w  =db_baolao(db_w,f0_woman)

fft_f_i=[0]*(1025)
fft_f=48000/NFFT
for i in range(1025):
    fft_f_i[i]=i*fft_f
#mfcc包咯
mfcc_baolao_man=mfcc_baolao(db_baolao_man,fft_f_i)
mfcc_baolao_w  =mfcc_baolao(db_baolao_w,fft_f_i)
#训练
erro=[0]*400
erro_i=[0]*400
a=0
mfcc_baolao_man_b=[0]*1024
mfcc_baolao_man_b2=[0]*1024
for i in range(-1000,1000,5):
    b=i/1000
    sum_erro=0
    for i_2 in range(1024):
        mfcc_baolao_man_b[i_2]=mfcc_baolao_man[i_2]*b
    for i_1 in range (1,1023):
        sum_erro=sum_erro+math.pow((mfcc_baolao_man_b[i_1] - mfcc_baolao_w[i_1]),2)
    erro[a]=sum_erro
    a=a+1
b=0
for i in range(-1000,1000,5):
    erro_i[b]=i/1000
    b=b+1

erro_min=0
erro_min_1=0
for i in range(400):
    if(i==0):
        erro_min=erro[i]
    if(erro_min<=erro[i]):
        erro_min=erro_min
    else :
        erro_min=erro[i]
        erro_min_1=erro_i[i]
print("erro_min",erro_min_1)
for i_2 in range(1024):
    mfcc_baolao_man_b2[i_2]=mfcc_baolao_man[i_2]*erro_min_1
# sf.write("y12000.wav",  y[70000:90000]/40000,sr)#读出音频
# sf.write("y_w12000.wav",  y_w[40000:60000]/40000,sr)#读出音频
# sf.write("训练音频测试/对齐1.wav",  data_path1,sr)#读出音频
# sf.write("训练音频测试/对齐2.wav",  data_path2,sr)#读出音频
path2=[0]*len2
path3=[0]*len2
for i in range(len2):
    path2[i]=path[i][0]
    path3[i]=path[i][1]

fig15 = plt.figure('对齐',figsize = (10,10)).add_subplot(211)
fig15.plot(data_path1,color='c')
fig15 = plt.figure('对齐',figsize = (10,10)).add_subplot(212)
fig15.plot(data_path2,color='y')
fig14 = plt.figure('对齐4',figsize = (10,10)).add_subplot(211)
fig14.plot(data_dtw_m_qnv,color='c')
fig14 = plt.figure('对齐4',figsize = (10,10)).add_subplot(212)
fig14.plot(data_dtw_w_qnv,color='y')
fig12 = plt.figure('对齐1',figsize = (10,10)).add_subplot(211)
fig12.set_title('y')
fig12.set_xlabel('Time (samples)')
fig12.set_ylabel('Amplitude')
fig12.plot(y[70000:90000],color='c')
fig12.plot(y_w[40000:60000],color='y')
# fig12.plot(y[70000:90000],color='c')
# fig12.plot(y_w[40000:60000],color='y')
fig12 = plt.figure('对齐1',figsize = (10,10)).add_subplot(212)
fig12.set_title('y')
fig12.set_xlabel('Time (samples)')
fig12.set_ylabel('Amplitude')
fig12.plot(data_path1,color='c')
fig12.plot(data_path2,color='y')

fig13 = plt.figure('222',figsize = (10,10)).add_subplot(111)
# plt.imshow(cost_matrix.T,origin='lower',cmap='gray')
fig13.plot(path2,path3,color='y')






fig11 = plt.figure('mfcc',figsize = (10,10)).add_subplot(211)
fig11.plot(mfcc_baolao_man,color='c')
fig11.plot(mfcc_baolao_w,color='y')

# fig11.plot(mfcc_baolao_man_b2,color='y')
fig11 = plt.figure('mfcc',figsize = (10,10)).add_subplot(212)
fig11.plot(mfcc_baolao_w,color='c')
fig11.plot(mfcc_baolao_man_b2,color='y')

fig12 = plt.figure('erro',figsize = (10,10)).add_subplot(111)
fig12.plot(erro_i,erro,color='y')




plt.show()




