"""
author:WenYiXxing
Times:2024.4.30

时域：实时
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
wlen=600#分帧帧长
inc =600#帧移长度
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
        y[i] = x[i] - (y[i-1]-y[i-1]/16)  # 一阶FIR滤波器
    return y  # 返回预加重以后的采样数组
#低通滤波器
def ditong(data,len):  # 定义预加重函数
     data2=[0]*len
     a=0.06
     for i in range(1, len, 1):
          data2[i]=(1-a)*data2[i-1]+a*data[i]
     return data2

data7=[0]*(int(wlen/4)*2)
sin_data=[0]*(wlen)
for i in range(int(wlen/4)*2):
        ranta=(math.sin(i*math.pi/(int(wlen/4)*2)))
        data7[i]=ranta*128

# for i in range(wlen):
#         if(i<=(int(wlen/6)+int(wlen/6/2))):
#             sin_data[i]=data7[i]

#         elif(i>(int(wlen/6)+int(wlen/6/2)) and i<=int(wlen/4)*2+int(wlen/4/2)):
#             sin_data[i]=data7[i-(int(wlen/4)+int(wlen/4/2)) +int(wlen/4/2)]      
#         elif(i>int(wlen/4)*2+int(wlen/4/2) and i<=wlen):
#             sin_data[i]=data7[i-(int(wlen/4)*2+int(wlen/4/2))+int(wlen/4/2)]

# for i in range(wlen):
#         if(i<=150):
#             sin_data[i]=data7[i]

#         elif(i>150 and i<=250):
#             sin_data[i]=data7[i-150 +int(wlen/6/2)]      
#         elif(i>250 and i<=350):
#             sin_data[i]=data7[i-250+int(wlen/6/2)]
#         elif(i>350 and i<=450):
#             sin_data[i]=data7[i-350+int(wlen/6/2)]
#         elif(i>450 and i<=600):
#             sin_data[i]=data7[i-450+int(wlen/6/2)]
# for i in range(wlen):
#         if(i<=225):
#             sin_data[i]=data7[i]

#         elif(i>225 and i<=375):
#             sin_data[i]=data7[i-225 +int(wlen/4/2)]      
#         elif(i>375 and i<=600):
#             sin_data[i]=data7[i-375+int(wlen/4/2)]

for i in range(wlen):
        if(i<=180):
            sin_data[i]=data7[i]

        elif(i>180 and i<=240):
            sin_data[i]=data7[i-180 +120]      
        elif(i>240 and i<=300):
            sin_data[i]=data7[i-240+120]
        elif(i>300 and i<=360):
            sin_data[i]=data7[i-300+120]
        elif(i>360 and i<=420):
            sin_data[i]=data7[i-360+120]
        elif(i>420 and i<=600):
            sin_data[i]=data7[i-420+120]
a = plt.figure('TD-PSOLA',figsize = (8,8)).add_subplot(414)
a.plot(sin_data,color='c')
plt.show()

# np.savetxt('sin.txt',sin_data,fmt='%d')

times = librosa.get_duration(path="D:/PDS_FPGA/Audio_python_test/C 变声测试音频/变声测试音频样本男.mp3")  # 获取音频时长
y, sr = librosa.load(path="D:/PDS_FPGA/Audio_python_test/C 变声测试音频/变声测试音频样本男.mp3", sr=48000, offset=0.0, duration=None)
y_w, sr_w = librosa.load(path="D:/PDS_FPGA/Audio_python_test/C 变声测试音频/变声测试音频样本女.m4a", sr=48000, offset=0.0, duration=None)

y=y*40000
y_w=y_w*40000
data,nf=Framing_fun(y_w)

f_set=400
f_yuan=240
p=f_set/f_yuan
# data2=[[0]*wlen]*nf
data2=np.zeros((nf,wlen))
data4=np.zeros((nf,int(wlen)))
data5=np.zeros((nf,int(wlen)))
data6=np.zeros((nf,int(wlen)))
data8=np.zeros((nf,int(wlen)))
wlen_2=wlen
data_chuli=np.zeros((nf,wlen+wlen_2))
if(p>=1):#升调
    for i in range(nf-1):
        for i_1 in range(wlen):
            data_chuli[i][i_1]=data[i][i_1]
        for i_2 in range(wlen,wlen+wlen_2):
            data_chuli[i][i_2]=data[i+1][i_2-wlen]       
else:#降调
    for i in range(nf-1):
        for i_1 in range(wlen):
            data_chuli[i][i_1]=data[i][i_1]
        for i_2 in range(wlen,wlen+wlen_2):
            data_chuli[i][i_2]=0   

for i in range(nf-1):
    for i_1 in range(wlen):
        pn=p*i_1
        if(pn<=wlen-1+wlen_2):
            data2[i][i_1]=data_chuli[i][int(pn)+1]*(pn-int(pn))+data_chuli[i][int(pn)]*(1-(pn-int(pn)))
        # elif(pn>wlen-1+wlen_2 and pn<=2*wlen-1+wlen_2):
        #     data2[i][i_1]=data_chuli[i+1][wlen-1+wlen_2-(int(pn)+1)]*(pn-int(pn))+data_chuli[i+1][wlen-1+wlen_2-int(pn)]*(1-(pn-int(pn)))
        else:
            data2[i][i_1]=data_chuli[i+1][2*wlen-1+wlen_2-(int(pn)+1)]*(pn-int(pn))+data_chuli[i+1][2*wlen-1+wlen_2-int(pn)]*(1-(pn-int(pn)))
# for i in range(nf-1):
#     for i_1 in range(int(wlen/4)*2):
#             data4[i][i_1]=data2[i][i_1]*data7[i_1]
#     for i_2 in range(int(wlen/4)*1,int(wlen/4)*3):
#             data5[i][i_2]=data2[i][i_2]*data7[i_2-int(wlen/4)]  
#     for i_5 in range(int(wlen/4)*2,wlen):
#             data6[i][i_5]=data2[i][i_5]*data7[i_5-int(wlen/4)*2]  

#     for i_3 in range(int(wlen/4)+int(wlen/4/2)):
#             data8[i][i_3]=data4[i][i_3]  
#     for i_4 in range(int(wlen/4)+int(wlen/4/2),int(wlen/4)*2+int(wlen/4/2)):
#             data8[i][i_4]=data5[i][i_4]
#     for i_6 in range(int(wlen/4)*2+int(wlen/4/2),wlen):
#             data8[i][i_6]=data6[i][i_6]                     
#     # for i_2 in range(int(wlen/2)):
#     #         data4[i][i_2]=data4[i][i_2]
#     # for i_3 in range(int(wlen/2),int(wlen/2)):
#     #         data4[i][i_3]=data4[i][i_1]
#     data4[i]=ditong(data8[i],wlen)
datap=[0]*wlen
for i in range(nf-1):#调制加滤波
    for i_1 in range(wlen):
            # data4[i][i_1]=data2[i][i_1]*sin_data[i_1]/128
            a=0.06*128
            datap[i_1]=data2[i][i_1]*sin_data[i_1]*a
            data4[i][i_1]=data4[i][i_1-1] *(128-a)/128 +datap[i_1]/16384
            # k1=0.1
            # k2=0.2
            # k3=0.3
            # k4=0.1
            # k5=0.1
            # datap[i_1]=(data2[i][i_1]*sin_data[i_1]*k1+data2[i][i_1-1]*sin_data[i_1]*k2+data2[i][i_1-2]*sin_data[i_1]*k3)/128
            # data4[i][i_1]=(datap[i_1]+data4[i][i_1-1]*k4+data4[i][i_1-2]*k5)
            
                         
    # data4[i]=ditong(data4[i],wlen)

data3=[0]*(nf*wlen)
for i in range(nf-1):
    data3[i*inc:i*inc+inc]=data4[i]/40000

sf.write("训练音频测试/时域14.wav",  data3,sr)#读出音频
fig9 = plt.figure('aaa',figsize = (10,10)).add_subplot(221)
fig9.plot(data[200],color='c')
# fig9.plot(sin_data,color='c')
y_w=pre_add(y_w)
fig9 = plt.figure('aaa',figsize = (10,10)).add_subplot(222)
# fig9.plot(data[201],color='b')
fig9.plot(data_chuli[200],color='y')

fig9 = plt.figure('aaa',figsize = (10,10)).add_subplot(223)
fig9.plot(data2[200],color='y')

fig9 = plt.figure('aaa',figsize = (10,10)).add_subplot(224)
fig9.plot(data4[200],color='y')

fig2 = plt.figure('m00000',figsize = (9,9)).add_subplot(211)
fig2.plot(y_w,color='b')
fig2 = plt.figure('m00000',figsize = (9,9)).add_subplot(212)
fig2.plot(data3,color='b')


plt.show()