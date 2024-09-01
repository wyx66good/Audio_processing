import os, sys
import numpy as np
from scipy import signal
import librosa.display
import soundfile as sf

N = 4096; #STFT Frame Size
H = 1024; #STFT Hop Size
L_h = 3; #Harmonic (Horizontal) Median Filter Length
L_p = 9; #Percussive (Vertical) Median Filter Length

filepath = 'F:\Study\McGill\MUMT 621\Project\Final Project\HP Dataset';
filepath2 = 'wreck_15_34';

x, fs = librosa.load(path="D:/PDS_FPGA/Audio_python_test/人声分离/人声分离测试音频样本.m4a", mono=True, sr=48000) #Loads and converts stereo to mono
X = librosa.stft(x, n_fft=N, hop_length=H, win_length=N, window='hann', center=True, pad_mode='constant'); #STFT of the Signal
S = np.abs(X)**2; #Spectrogram


S_h = signal.medfilt(S, [1, L_h]); #Median Filter in Horizontal Direction (Harmonic)
S_p = signal.medfilt(S, [L_p, 1]); #Median Filter in Vertical Direction (Percussive)

M_h = (S_h + 0.0000005)/(S_h + S_p + 0.000001); #Soft Mask for Harmonic Components (Power Law)
M_p = (S_p + 0.0000005)/(S_h + S_p + 0.000001); #Soft Mask for Percussive Components (Power Law)

X_h = X * M_h; #Harmonic Components
X_p = X * M_p; #Percussive Components

x_h = librosa.istft(X_h, hop_length=H, win_length=N, window='hann', center=True, length=x.size); #Harmonic Signal
x_p = librosa.istft(X_p, hop_length=H, win_length=N,  center=True, length=x.size); #Percussive Signal

sf.write("D:/PDS_FPGA/Audio_python_test/人声分离/c_A2.wav", x_h, fs)
sf.write("D:/PDS_FPGA/Audio_python_test/人声分离/c_E.wav", x_p, fs)

