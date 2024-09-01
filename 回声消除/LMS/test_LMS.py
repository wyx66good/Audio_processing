import numpy as np
import librosa
import math
import soundfile as sf
import pyroomacoustics as pra
from matplotlib import pyplot
import matplotlib.pyplot as plt  # 导入绘图工作的函数集合

# x 参考信号
# d 麦克风信号
# N 滤波器阶数
# mu 迭代步长
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

def lms(x, d, N = 4, mu = 0.1):
  nIters = min(len(x),len(d)) - N
  u = np.zeros(N)
  w = np.zeros(N)
  w1 = np.zeros(N)
  e = np.zeros(nIters)
  for n in range(nIters):
    u[1:] = u[:-1]
    u[0] = x[n]
    a=np.dot(u.T,u)
    mu1=mu/(0.0001+a)
    e_n = d[n] +np.dot(u, w1)
    w = w + mu * e_n * u
    w1 = w1 + mu1 * e_n * u
    e[n] = e_n
  return e,mu1,w1

def nlms(x, d, N=4, mu=1/16):
    # NLMS迭代步数
    n_Iters = min(len(x), len(d))
    u = np.zeros(N)     # 每次输入自适应滤波器的信号
    w = np.zeros(N)     # 滤波器权重系数
    # w11=np.zeros(int((n_Iters/5)*N))
    w11=0
    e = np.zeros(n_Iters)   # 误差信号
    e2 = np.zeros(n_Iters)   # 误差信号
    i=20
    e_n1=0
    u1=pow(2, -28)
    for n in range(n_Iters):
        u[1:] = u[:-1]
        u[0] = x[n]

        y=np.dot(u, w)
        
        e_n = d[n] -y #int(np.nan_to_num(y/pow(2, 4)))#np.dot(u, w)
        # w = w + u * e_n1 * u1
        # w = w + mu * e_n * u / (np.dot(u, u))
        # a=e_n * u*pow(2, 16)
        # b=np.nan_to_num(a/(np.dot(u, u)))
        # c=b*pow(2, -20)
        # w = w+e_n * u/(np.dot(u, u))
        # w = w + mu * e_n * u / (np.dot(u, u))
        # e_n1=e_n
        a=mu *e_n * u / (np.dot(u, u))
        w = w + a #e_n * u / (np.dot(u, u))

        # u1= mu/ (np.dot(u, u)+2 )

        # u1 = np.clip(u1, 0, 1)
        
        
        # if(n<int(n_Iters/5)):
        #     w11[n*N:n*N+N]=w
        e2[n] =y
        e[n] = e_n
    return e,w11,e2

# x 原始参考信号
# v 理想mic信号 
# 生成模拟的mic信号和参考信号
def creat_sim_sound(x,v):
    rt60_tgt = 0.2
    room_dim = [2, 2, 2]

    e_absorption, max_order = pra.inverse_sabine(rt60_tgt, room_dim)
    room = pra.ShoeBox(room_dim, fs=sr, materials=pra.Material(e_absorption), max_order=max_order)
    room.add_source([1.5, 1.5, 1.5])
    room.add_microphone([0.1, 0.5, 0.1])
    room.compute_rir()
    rir = room.rir[0][0]
    rir = rir[np.argmax(rir):]
    # x 经过房间反射得到 y
    y = np.convolve(x,rir)
    scale = np.sqrt(np.mean(x**2)) /  np.sqrt(np.mean(y**2))
    # y 为经过反射后到达麦克风的声音
    y = y*scale

    L = max(len(y),len(v))
    y = np.pad(y,[0,L-len(y)])
    v = np.pad(v,[L-len(v),0])
    x = np.pad(x,[0,L-len(x)])
    d = v + y
    return x,d

if __name__ == "__main__":

    # x_org, sr  = librosa.load("D:/PDS_FPGA/Audio_python_test/回声消除/LMS/x-d2.wav",sr=48000)
    # v_org, sr  = librosa.load("D:/PDS_FPGA/Audio_python_test/回声消除/LMS/x-x2.wav",sr=48000)
    # x_org =x_org*1000
    # v_org =v_org*1000
    # # np.savetxt('D:/PDS_FPGA/Audio_python_test/回声消除/x-d.txt',x_org,fmt='%b')
    # # np.savetxt('D:/PDS_FPGA/Audio_python_test/回声消除/x-x.txt',v_org,fmt='%b')
    # file_hander = open("D:/PDS_FPGA/Audio_python_test/回声消除/LMS/x-d.txt", 'w')
    # file_hander2 = open("D:/PDS_FPGA/Audio_python_test/回声消除/LMS/x-x.txt", 'w')
    # for i in range(40000):
    #     a=x_org[i]
    #     b=v_org[i]
    #     a=int(a)
    #     b=int(b)
    #     if a>=0:
    #         d2b = bin(a)[2:]#'{:018b}'.format(a)
    #     else:
    #         d2b = bin(a)[3:]#'{:018b}'.format(a)
    #     if b>=0:
    #         d2b2 = bin(b)[2:]#'{:018b}'.format(a)
    #     else:
    #         d2b2 = bin(b)[3:]#'{:018b}'.format(a)
    #     # d2b2 = bin(b)[2:]#'{:018b}'.format(b)
    #     file_hander.write(d2b + '\n')
    #     file_hander2.write(d2b2 + '\n')
    # with open("D:/PDS_FPGA/Audio_python_test/回声消除/LMS/x-d.txt",'wb' ) as f:
    #     f.write(x_org)    
    # with open("D:/PDS_FPGA/Audio_python_test/回声消除/LMS/x-x.txt",'wb' ) as f:
    #     f.write(v_org)    
    # file_hander.close()
    # file_hander2.close()




    x_org, sr  = librosa.load("D:/PDS_FPGA/Audio_python_test/回声消除/LMS/张杰 - 着魔.mp3",sr=48000)
    v_org, sr  = librosa.load("D:/PDS_FPGA/Audio_python_test/回声消除/LMS/张杰 - 柔光灯.mp3",sr=48000)
    x_org=x_org
    v_org=v_org

    x,d = creat_sim_sound(x_org,v_org) 
    # d2 = np.zeros(len(d)+10000)  
    # x =x*4000
    # d =d*4000
    # x1,fn1 = Framing_fun(x)
    # d1,fn2 = Framing_fun(d)
    # if(fn1>fn2):
    #     fn=fn1
    # else:
    #     fn=fn2
    # e ,w=  nlms(x, d,N=1024, mu=0.1)
    # d1=np.zeros(int(len(d)+len(d)/2))

    # fft_in=[0]*1200
    # fft_in=x[600*1200:600*1200+1200]
    # fft_in_d=[0]*1200
    # fft_in_d=d[600*1200:600*1200+1200]
    # np.savetxt('x.txt',x,fmt='%d')
    # np.savetxt('d.txt',d,fmt='%d')
  #  x = x*math.pow(2,15)d
  #  x=x.astype(int)
  #  x=x-1
  #  d = d*math.pow(2,15)
  #  d=d.astype(int)
  #  d=d-1
    # e1 =  lms(x, d,N=1024,mu=0.0000000000002)/4000
    # e =  lms(x, d,N=8, mu=0.0000000025)/4000
    e ,w,e2=  nlms( x,d,N=512,mu=1/64)
    # e=e/1500
#    d = d*math.pow(2,15)
#   e = e*math.pow(2,15)
#  np.savetxt('data_e.txt',e,fmt='%d')
#    np.savetxt('data_d.txt',d[:38000],fmt='%d')
    sf.write("D:/PDS_FPGA/Audio_python_test/回声消除/LMS/x-x2-2.wav", x, sr)
    sf.write("D:/PDS_FPGA/Audio_python_test/回声消除/LMS/x-d2-2.wav", d, sr)
    sf.write("D:/PDS_FPGA/Audio_python_test/回声消除/LMS/x-lms-1024-16.wav", e, sr)
    fig2 = plt.figure('m00000',figsize = (9,9)).add_subplot(311)
    fig2.plot(x,color='b')
    fig2 = plt.figure('m00000',figsize = (9,9)).add_subplot(312)
    # fig2.plot(e1,color='c')
    fig2.plot(x[:200000],color='b')
    fig2.plot(e2[:200000],color='y')
    fig2 = plt.figure('m00000',figsize = (9,9)).add_subplot(313)
    # fig2.plot(e1,color='c')
    
    fig2.plot(w[0:12000000],color='b')
    # fig2.plot(x/8000,color='y')
    fig3 = plt.figure('aaa',figsize = (9,9)).add_subplot(211)
    fig3.plot(x,color='b')
    fig3 = plt.figure('aaa',figsize = (9,9)).add_subplot(212)
    fig3.plot(d,color='y')

    plt.show()
