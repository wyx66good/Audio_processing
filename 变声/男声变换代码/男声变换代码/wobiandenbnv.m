%������Ů��
function Y=voicel(x)
[x,fs]=audioread('man.wav'); %��ȡ���������ź�
%��ʾƵ�׼�����
xt=x(:,1);
figure(1);
tend=length(xt)/fs;
t=linspace(0,tend,length(xt));
subplot(2,1,1);plot(t,xt);grid
title('�����ź�song3');xlabel('t(s)');ylabel('y');
XT=fft(xt);
Ts=t(2)-t(1);
ws=1/Ts;
wn=ws/2;
w=linspace(0,wn,length(t)/2);
if mod(length(t),2)==0
    tnum=length(t)/2;
else
    tnum=(length(t)-1)/2;
end
XT=abs(XT(1:1:tnum));
subplot(2,1,2);plot(w,XT);axis([0 4000 0 1000]);grid;
title('�����ź�song3��Ƶ��');xlabel('f (Hz)');ylabel('Y');
%
d=resample(x,2,3);%�ز����������Ƶ
%ʱ��������ʹ�����źŻָ�Ϊԭ����ʱ��
W=800;  %�����ȣ�������ܴ���������źŵ���С����
Wov=W/2;  %��һ��������ǰһ����������ӵĳ���
Kmax=W*2;%����ʱ�ӣ���������Ϊ��������źŵ�β����һ�¶����뷢����ʱ��
Wsim=Wov;
xdecim=8;
kdecim=2;
X=d'; %�ز�������źŸ�ֵ��X
F=1.5;
Ss=W-Wov;%�ۺ�ʱ�ӣ�����������������׵�ַ֮��ļ��
xpts=size(X,2);
ypts=round(xpts/F);
Y=zeros(2,ypts);%�����������ź���ͬ��С��0���󣬴洢�ϳɵ������ź�
xfwin=(1:Wov)/(Wov+1);
ovix=(1-Wov):0;
newix=1:(W-Wov);
simix=(1:xdecim:Wsim)-Wsim;
for i=1:2 %������ѭ����������ά�ȷֱ���
padX(i,:)=[zeros(1,Wsim),X(i,:),zeros(1,Kmax+W-Wov)];
Y(i,1:Wsim)=X(i,1:Wsim);
xabs=0;
lastxpos=0;
km=0;
for ypos=Wsim:Ss:(ypts-W);
    xpos=F*ypos;
    kmpred=km+(xpos-lastxpos); 
    lastxpos=xpos;
    if(kmpred<=Kmax)
        km=kmpred;
    else
        ysim=Y(i,ypos+simix);
        rxy=zeros(1,Kmax+1);
        rxx=zeros(1,Kmax+1);
        Kmin=0;
        for k=Kmin:kdecim:Kmax
            xsim=padX(i,Wsim+xpos+k+simix);
            rxx(k+1)=norm(xsim);
            rxy(k+1)=(ysim*xsim');
        end
        Rxy=(rxx~=0).*rxy./(rxx+(rxx==0));
        km=min(find(Rxy==max(Rxy))-1);
    end
    xabs=xpos+km;
    Y(i,ypos+ovix)=((1-xfwin).*Y(i,ypos+ovix))+(xfwin.*padX(i,Wsim+xabs+ovix));
    Y(i,ypos+newix)=padX(i,Wsim+xabs+newix);
end
end
%��ʾƵ�׼�����
yt=Y(1,:);
figure(2);
tendy=length(yt)/fs;
ty=linspace(0,tendy,length(yt));
subplot(2,1,1);plot(ty,yt);grid
title('�����������ź�song3');xlabel('t(s)');ylabel('y');
YT=fft(yt);
Tsy=ty(2)-ty(1);
wsy=1/Tsy;
wny=wsy/2;
wy=linspace(0,wny,length(ty)/2);
if mod(length(ty),2)==0
    tnumy=length(ty)/2;
else
    tnumy=(length(ty)-1)/2;
end
YT=abs(YT(1:1:tnumy));
subplot(2,1,2);plot(wy,YT);axis([0 4000 0 1000]);grid;
title('�����������ź�song3��Ƶ��');xlabel('f (Hz)');ylabel('Y');
%
sound(Y,fs);
end