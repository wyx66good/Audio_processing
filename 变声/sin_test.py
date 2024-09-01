import numpy as np
import matplotlib.pyplot as plt
import soundfile as sf
def sin_wave(A, f, fs, phi, t):
    '''
    :params A:    振幅
    :params f:    信号频率
    :params fs:   采样频率
    :params phi:  相位
    :params t:    时间长度
    '''
    # 若时间序列长度为 t=1s, 
    # 采样频率 fs=1000 Hz, 则采样时间间隔 Ts=1/fs=0.001s
    # 对于时间序列采样点个数为 n=t/Ts=1/0.001=1000, 即有1000个点,每个点间隔为 Ts
    Ts = 1/fs
    n = t / Ts
    n = np.arange(n)
    y = A*np.sin(2*np.pi*f*n*Ts + phi*(np.pi/180))
    return y

test=sin_wave(A=4000, f=200, fs=48000, phi=60, t=0.02132)#0.02132

fft_in=[0]*1200
for i in range (1200):
    fft_in[i]=i
np.savetxt('test3.txt',fft_in,fmt='%d')
# fft=np.fft.fft(fft_in,1024) 
# fft2=np.fft.ifft(fft) 
# a=1
# # 计算序列组成单元之间的距离，可以是欧氏距离，也可以是任何其他定义的距离,这里使用绝对值
# def distance(w1,w2):
#     d = abs(w2 - w1)
#     return d

# # DTW计算序列s1,s2的最小距离
# def DTW(s1,s2):
#     m = len(s1)
#     n = len(s2)

#     # 构建二位dp矩阵,存储对应每个子问题的最小距离
#     dp = [[0]*n for _ in range(m)] 

#     # 起始条件,计算单个字符与一个序列的距离
#     for i in range(m):
#         dp[i][0] = distance(s1[i],s2[0])
#     for j in range(n):
#         dp[0][j] = distance(s1[0],s2[j])
    
#     # 利用递推公式,计算每个子问题的最小距离,矩阵最右下角的元素即位最终两个序列的最小值
#     for i in range(1,m):
#         for j in range(1,n):
#             dp[i][j] = min(dp[i-1][j-1],dp[i-1][j],dp[i][j-1]) + distance(s1[i],s2[j])
    
#     return dp

# s1 = [1,3,2,4,2]
# s2 = [0,3,4,2,2]

# print('DTW distance: ',DTW(s1,s2))   # 输出 DTW distance:  2

# def loadtxtmethod(filename):
#     data = np.loadtxt(filename,dtype=np.float32,delimiter=',')
#     return data
 

# data = loadtxtmethod('t4.txt')
# print(data)
# for i in range (1025):
#     data [i]=data[i]/10
# print(data)
# np.savetxt('t5.txt',data,fmt='%d')
