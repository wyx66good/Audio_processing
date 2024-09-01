import numpy as np
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
# # import torchaudio
# def center(X):
#     """标准化数据，使其均值为0"""
#     return X - X.mean(axis=0, keepdims=True)
#     #沿着行的方向取均值，即计算n个麦克风在m个时刻中的均值，X_means的shape是(n,)
#     # X_means = np.mean(X,axis = 0)
#     # #将X_means增加一个新行，shape变为(n,1),X的每一列都与之对应相减
#     # return X-X_means[:, np.newaxis]

# def whiten(X):
#     # 对数据进行中心化
#     X_centered = center(X)
#     # 计算协方差矩阵
#     cov = np.dot(X_centered.T, X_centered) / (X_centered.shape[0] - 1)
#     # 对协方差矩阵进行奇异值分解
#     U, S, _ = np.linalg.svd(cov)
#     # 计算白化矩阵
#     W = np.dot(U, np.dot(np.diag(1.0 / np.sqrt(S + 1e-5)), U.T))
#     # 应用白化矩阵
#     X_white = np.dot(X_centered, W)
#     return X_white
# def g(u):
#     """确定非高斯性度量函数"""
#     return np.tanh(u)
# def g_deriv(u):
#     """非高斯性度量函数的导数"""
#     return 1 - np.square(np.tanh(u))
# def fast_ica(X, n_components, max_iter, tol=1e-4):
#     """
#     FastICA 算法实现独立成分分析
#     Parameters:
#         X: array-like, shape (n_samples, n_features)
#             观测数据
#         n_components: int
#             需要分离的成分个数
#         max_iter: int
#             最大迭代次数
#         tol: float
#             收敛阈值，当两次迭代的迭代步长小于 tol 时，认为已经收敛
#     Returns:
#         S: array-like, shape (n_components, n_samples)
#             分离后的信号
#         A: array-like, shape (n_components, n_components)
#             待求解的混合矩阵的估计值
#     """
#     # 标准化数据
#     X_centered = center(X)
#     # 对中心化后的数据进行白化处理
#     X_white = whiten(X_centered)
#     # 初始化权重 W
#     n_samples, n_features = X_white.shape
#     W = np.random.rand(n_components, n_components)
#     # 迭代优化
#     for iter_num in range(max_iter):
#         # 计算估计的信号 S
#         S = np.dot( X_white,W)
#         S = g(S)
#         # 计算估计的混合矩阵 A
#         dW = np.zeros_like(W)
#         for i in range(n_components):
#             for j in range(n_components):
#                 dW[i, j] = np.mean(X_white[j, :] * S[i, :]) - np.mean(g_deriv(S[i, :]) * W[i, j])
#         # 更新权重 W
#         W += 0.1 * dW
#         # 判断是否收敛
#         if iter_num > 1:
#             step_size = np.max(np.abs(W - W_old))
#             if step_size < tol:
#                 break
#         W_old = W.copy()
#     # 计算分离后的信号和混合矩阵
#     S = np.dot(X_white,W)
#     A = np.linalg.inv(W)
#     return S, A


# y, sr = librosa.load(path="D:/PDS_FPGA/Audio_python_test/人声分离/人声分离测试音频样本.m4a", sr=48000, offset=0.0, duration=None)

# S, A=fast_ica(y,2,50)

# librosa.decompose
# sf.write("D:/PDS_FPGA/Audio_python_test/人声分离/S.wav",  S,sr)#读出音频
# sf.write("D:/PDS_FPGA/Audio_python_test/人声分离/A.wav",  A,sr)#读出音频
from scipy import signal

x = np.random.randint(1,1000,(4,4))
print(x,"\n")
x = signal.medfilt(x,(5,1)) #二维中值滤波
print(x)



def stft_basic(x, w, H=8, only_positive_frequencies=False):
    """Compute a basic version of the discrete short-time Fourier transform (STFT)
    Args:
        x (np.ndarray): Signal to be transformed
        w (np.ndarray): Window function
        H (int): Hopsize
        only_positive_frequencies (bool): Return only positive frequency part of spectrum (non-invertible)
            (Default value = False)
    Returns:
        X (np.ndarray): The discrete short-time Fourier transform
    """
    N = len(w)
    L = len(x)
    M = np.floor((L - N) / H).astype(int) + 1
    X = np.zeros((N, M), dtype='complex')
    for m in range(M):
        x_win = x[m * H:m * H + N] * w
        X_win = np.fft.fft(x_win)
        X[:, m] = X_win

    if only_positive_frequencies:
        K = 1 + N // 2
        X = X[0:K, :]
    return X


def istft_basic(X, w, H, L):
    """Compute the inverse of the basic discrete short-time Fourier transform (ISTFT)
    Args:
        X (np.ndarray): The discrete short-time Fourier transform
        w (np.ndarray): Window function
        H (int): Hopsize
        L (int): Length of time signal
    Returns:
        x (np.ndarray): Time signal
    """
    N = len(w)
    M = X.shape[1]
    x_win_sum = np.zeros(L)
    w_sum = np.zeros(L)
    for m in range(M):
        x_win = np.fft.ifft(X[:, m])
        x_win = np.real(x_win) * w
        x_win_sum[m * H:m * H + N] = x_win_sum[m * H:m * H + N] + x_win
        w_shifted = np.zeros(L)
        w_shifted[m * H:m * H + N] = w * w
        w_sum = w_sum + w_shifted
    # Avoid division by zero
    w_sum[w_sum == 0] = np.finfo(np.float32).eps
    x_rec = x_win_sum / w_sum
    return x_rec, x_win_sum, w_sum
    
     
      
L = 256
t = np.arange(L) / L
omega = 4
x = np.sin(2 * np.pi * omega * t * t)

N = 64
H = 3 * N // 8
w_type = 'hann'
w = np.hamming( N)
X = stft_basic(x, w=w, H=H)
x_rec, x_win_sum, w_sum = istft_basic(X, w=w, H=H, L=L)

plt.figure(figsize=(8, 3))
# plt.plot(x, color=[0, 0, 0], linewidth=4, label='Original signal')
plt.plot(w_sum, color=[1, 0, 0], linewidth=4, label='Reconstructed signal')
plt.xlim([0,L-1])
plt.legend(loc='lower left')
plt.show()

