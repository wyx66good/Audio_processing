%Ů��������
function Y=voicel(x)
[x,fs]=audioread('song2.wav'); 
d=resample(x,5,3);%�ز��������ͻ�Ƶ
%ʱ��������ʹ�����źŻָ�Ϊԭ����ʱ��
W=400;  %�����ȣ�������ܴ���������źŵ���С����
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
sound(Y,fs);
end