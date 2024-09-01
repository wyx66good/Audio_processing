# 读取音频文件
import numpy as np
import librosa.display  # 导入音频及绘图显示
import matplotlib.pyplot as plt  # 导入绘图工作的函数集合
import soundfile as sf
import math
import librosa.display   #画声谱图用
import librosa.core as lc   #计算stft使用
from scipy.fftpack import fft,dct

# 绘制频谱图
def plot_spectrogram(spec, note):
    # fig = plt.figure(figsize=(5, 5))
    heatmap = plt.pcolor(spec)
    plt.colorbar(mappable=heatmap)
    plt.xlabel('Time(s)')
    plt.ylabel(note)
    plt.tight_layout()

# 预加重   s′(n)=s(n)－as(n－1)(a为常数)su
def pre_add(x):  # 定义预加重函数
    signal_points=len(x)  # 获取语音信号的长度
    signal_points=int(signal_points)  # 把语音信号的长度转换为整型
    for i in range(1, signal_points, 1):# 对采样数组进行for循环计算
        x[i] = x[i] - 0.9375 * x[i - 1]  # 一阶FIR滤波器
    return x  # 返回预加重以后的采样数组

# 分帧
wlen=400#分帧帧长
inc =300#帧移长度
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
    return frames

if __name__ == '__main__':

# def MFCC(path):
    
    # 读取语音文件并绘制波形图
    # print(">>> 开始读取语音数据")
    # print("*******************")
    # times = librosa.get_duration(path=path)  # 获取音频时长
    # y, sr = librosa.load(path=path, sr=8000, offset=0.0, duration=None)
    # y, sr =librosa.resample(y.astype(np.float32), 1/sr, 16000)
    # x = np.arange(0, times-0.0046, 1/sr) # 时间刻度-0.0384
    # print(">>> 读取语音数据完成")
    # print("*******************")
    # print('times:',times)
    # print(len(x),len(y))
    # print("sr:",sr)
    # # #一个画布多图
    # fig1 = plt.figure('预加重',figsize = (8,8)).add_subplot(221)
    # plt.plot(x,y)
    # fig1.set_title('contrast')
    # fig1.set_xlabel('times')
    # fig1.set_ylabel('amplitude')
    
    # pre_exa = pre_add(y)  # 函数调用
    # plt.plot(x, pre_exa)  # 绘出图形
    # print(">>> 分帧加窗")
    # print("*******************")
    Framing_data=Framing_fun(pre_add(y))
    hanning_windown=np.hanning(wlen)  #调用汉明窗
    # print(">>> 分帧加窗完成")
    # print("*******************")

    nfilt = 40
    low_freq_mel = 0
    # fft
    signal2_len=len(y)# 获取语音信号的长度
    if signal2_len<=wlen: 
        nf2=1
    else:                
        nf2=int(np.ceil((1.0*signal2_len-wlen+inc)/inc))
    # x = np.arange(wlen)           # 频率个数
    After_filter=np.zeros((nf2,nfilt))
    filter_banks=np.zeros((nf2,nfilt))
    # print(">>> 开始MFCC滤波")
    # print("*******************")
    for i in range(nf2): #帧数
        Framing_data_litter=Framing_data[i:i+1]
        y_hanning_windown=hanning_windown*Framing_data_litter[0]
        fft_y=np.fft.rfft(y_hanning_windown,NFFT) #快速傅里叶变换，取一半
        x = np.arange(NFFT)           # 频率个数
        abs_y=np.abs(fft_y)              # 取复数的绝对值，即复数的模(双边频谱)
        ps = abs_y**2 / NFFT #功率谱
        high_freq_mel = (2595 * np.log10(1 + (sr / 2) / 700))  # 求最高hz频率对应的mel频率
        #  我们要做40个滤波器组，为此需要42个点，这意味着在们需要low_freq_mel和high_freq_mel之间线性间隔40个点
        mel_points = np.linspace(low_freq_mel, high_freq_mel, nfilt + 2)  # 在mel频率上均分成24个点
        hz_points = (700 * (10**(mel_points / 2595) - 1))  # 将mel频率再转到hz频率
        bins = np.floor((NFFT + 2)*hz_points/sr)
        w=int(np.floor(NFFT / 2 + 1))
        df=sr/wlen
        fr=[]
        for n in range(w):
            frs=int(n*df)
            fr.append(frs)
        melbank=np.zeros((nfilt,w))
        for k in range(nfilt+1):
            f_m_min =int(bins[k-1])#左
            f_m     =int(bins[k]  )#中
            f_m_plus=int(bins[k+1])#右
            for g in range(f_m_min, f_m):
                melbank[k - 1, g] = (g - bins[k - 1]) / (bins[k] - bins[k - 1])
            for g in range(f_m, f_m_plus):
                melbank[k - 1, g] = (bins[k + 1] - g) / (bins[k + 1] - bins[k])
        filter_banks[i,] = np.dot(ps, melbank.T)
        filter_banks[i,] = np.where(filter_banks[i,] == 0, np.finfo(float).eps, filter_banks[i,])  # 数值稳定性
        filter_banks[i,] = 20 * np.log(filter_banks[i,])  # dB
            # After_filter[i,k-1]=filter_banks
            # plt.plot(fr, melbank[k - 1,])
    # print(">>> MFCC滤波完成",melbank.shape)
    # print("*******************")

    # plt.figure('bbb',figsize = (8,8)).add_subplot(111)
    # plot_spectrogram(filter_banks.T, 'filter_banks filter_banks')

    # # print(">>> 计算对数能量")
    # # print("*******************")
    # logs=np.log(After_filter+1e-5) #取对数  对数梅尔谱图特征
    
    # num_ceps=30#选取前几个特征
    # # print(">>> DCT倒谱")
    # # print("*******************")
    # #DCT倒谱
    # DCT = dct(logs,type = 2,axis = 0,norm = 'ortho')[:,1 : (num_ceps + 1)]
    # mfcc = dct(filter_banks, type=2, axis=1, norm='ortho')[:, 1:(num_ceps+1)]
    # # print("captcha_array :",mfcc.T.shape)
    # # print("len_captcha_array :",len(mfcc.shape))
    
    
    # # print(">>> 成功提取MFCC特征")
    # # print("*******************")
    # # print(">>> 进入CNN模型")
    # fig1 = plt.figure('预加重',figsize = (8,8)).add_subplot(222)
    # plot_spectrogram(mfcc.T, 'mfcc Banks')
    # # 正弦提升（sinusoidal liftering）操作wi​=2/D*​sin(π∗i/d​) ;MFCCi′​=wi​MFCCi
    # cep_lifter = 24
    # (nframes, ncoeff) = mfcc.shape
    # n = np.arange(ncoeff)
    # lift = 1 + (cep_lifter / 2) * np.sin(np.pi * n / cep_lifter)
    # mfcc *= lift
    # fig1 = plt.figure('预加重',figsize = (8,8)).add_subplot(223)
    # plot_spectrogram(mfcc.T, 'mfcc2 Banks')
    
    # #画语谱图
    # #获取窄带声谱图
    # # plt.figure()
    # fig1 = plt.figure('预加重',figsize = (8,8)).add_subplot(224)
    
    # mag1 = np.abs(lc.stft(y, n_fft=4000, hop_length=inc, win_length=wlen, window='hamming'))
    # # mag1_log = 20*np.log(mag1)
    # D1 = librosa.amplitude_to_db(mag1, ref=np.max)
    # librosa.display.specshow(D1, sr=sr, hop_length=inc, x_axis='s', y_axis='linear')
    # plt.colorbar(melbank='%+2.0f dB')
    # plt.title('narrowband spectrogram')
    # plt.savefig('narrowband.png')
    fig = plt.figure('y',figsize = (10,10)).add_subplot(511)
    fig.plot(melbank,color='y')
    
    plt.show()  # 显示
    # return np.float32(mfcc.T)

MFCC("D:/PDS_FPGA/Audio_python_test/C 变声测试音频/变声测试音频样本男.mp3")