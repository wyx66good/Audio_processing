%���������� (�����˲�������ȥ��Ƶ��������Ƶ�źţ�
x=audioread('song1.wav');
fp=600;%�����˲�������
fs=700;
Fs=8000;
wp=2*pi*fp/Fs;
ws=2*pi*fs/Fs;
wdelta=ws-wp;
N=ceil(6.6*pi/wdelta);
Wn=(wp+ws)/2;
b=fir1(N,Wn/pi,hamming(N+1));%hamming��
[H,W]=freqz(b,1,512);
t=0:1/Fs:0.2;
y=3*filter(b,1,x);       %����ϵ������������
figure(2);
plot(y);
sound(y,Fs);
grid on

