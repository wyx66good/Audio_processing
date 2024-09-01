%男声变老人 (采用滤波器，滤去高频，保留低频信号）
x=audioread('song1.wav');
fp=600;%设置滤波器参数
fs=700;
Fs=8000;
wp=2*pi*fp/Fs;
ws=2*pi*fs/Fs;
wdelta=ws-wp;
N=ceil(6.6*pi/wdelta);
Wn=(wp+ws)/2;
b=fir1(N,Wn/pi,hamming(N+1));%hamming窗
[H,W]=freqz(b,1,512);
t=0:1/Fs:0.2;
y=3*filter(b,1,x);       %乘以系数来增大音量
figure(2);
plot(y);
sound(y,Fs);
grid on

