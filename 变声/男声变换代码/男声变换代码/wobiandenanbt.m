%男变童声（采用频谱搬移实现）
[y,fs]=audioread('song1.wav');
Fs=8192;%采样频率为8192
pinyi=fft(y);%傅立叶变换，获得语音信号的频谱图
f=8192*[0:22000]/22001;
figure(1)
plot(f,abs(pinyi));
title('语音信号song1');xlabel('t(s)');ylabel('y');
grid on
axis([1,10000,0,250]);
hang=pinyi';
NN=4000;%定义频谱移动范围
pujialing=[hang(NN:22001),zeros(1,(NN-1))];%插值0，改变频谱，实现频谱搬移
pu=pujialing';
figure(2)
plot(f,2*abs(pu));
title('变换的语音信号song1');xlabel('t(s)');ylabel('y');
grid on
axis([1,10000,0,250]);
Y1=3*real(ifft(pu)); %傅立叶反变换
sound(Y1,fs); 
