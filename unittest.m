clear all;
clc;
close all;
t=0:0.001:0.5;

speech=sin(2*pi*100*t);
plot(t,speech) %original signal
grid on
title ('Original Signal')
fs=1002;
frame_dur=50000/fs;
 max_value=max(abs(speech));
 min_value=min(abs(speech));
speech=(speech-mean(speech)./(max(abs((speech - mean(speech))))));%Normalization
%frame_dur=20; %20 ms
 m=length(speech);%length of speech
x=speech(1:50);
figure,plot(x);

win = hamming(50);
% 
% 
 M=10;
 speech1 = win.*(x)'; %signal for first frame 
 t2=(0:length(speech1)-1)/fs;
figure,plot(t2,speech1)
 [A,G] = lpc(speech1,M); 
 
 speech2= clip_center(speech1);
 figure,plot(speech2)
 Rn= modified_autocorrelation( speech2);
a=length(round(fs/350):round(fs/80));
 Rnk=Rn(round(fs/350):round(fs/80));
 [R,indis]=max(Rnk); %find max values at 80<f0<350
 indis=round(fs/350)-1+indis;%indices of max R values
R0=Rn(1);
Rn0=R0*0.3;
k=indis;
pitchPeriod=[];
if R>=Rn0
        pitchPer=(k+fs/350); %frame is voiced
    else
       pitchPer=0;
    end
pitchPeriod=[pitchPeriod; pitchPer]; 
[signal t]=syn_lpc(fs,pitchPeriod,frame_dur,A,G*10^3);
%signal=signal*max(abs((speech - mean(speech))));
figure,
subplot(2,1,1)
plot(t2,speech1)
title('Original')
subplot(2,1,2)
plot(t,signal)
title('Synthesized')
%sound(signal,fs)


