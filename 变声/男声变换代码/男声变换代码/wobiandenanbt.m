%�б�ͯ��������Ƶ�װ���ʵ�֣�
[y,fs]=audioread('song1.wav');
Fs=8192;%����Ƶ��Ϊ8192
pinyi=fft(y);%����Ҷ�任����������źŵ�Ƶ��ͼ
f=8192*[0:22000]/22001;
figure(1)
plot(f,abs(pinyi));
title('�����ź�song1');xlabel('t(s)');ylabel('y');
grid on
axis([1,10000,0,250]);
hang=pinyi';
NN=4000;%����Ƶ���ƶ���Χ
pujialing=[hang(NN:22001),zeros(1,(NN-1))];%��ֵ0���ı�Ƶ�ף�ʵ��Ƶ�װ���
pu=pujialing';
figure(2)
plot(f,2*abs(pu));
title('�任�������ź�song1');xlabel('t(s)');ylabel('y');
grid on
axis([1,10000,0,250]);
Y1=3*real(ifft(pu)); %����Ҷ���任
sound(Y1,fs); 
