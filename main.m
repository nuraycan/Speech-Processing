% --------------------%
% EE519 Assignment 3  %
% NURAY GUL-130505009 %
%---------------------%
%This script is finding LPC coefficients and gains for a speech signal
% And it resynthesizes the speech by using these values %
%%
clear all;
clc;
close all;
[speech,fs,nbits] = wavread('word1Anger.wav'); % Read Mono speech
                                                 % fs=16000 Hertz
% sound(speech,fs)    % Listen it                            
% Normalization
speech=(speech-mean(speech)./(max(abs((speech - mean(speech))))));%Normalize the signal
% Frame Properties
frame_dur=20; %20 ms
FrameLen=frame_dur*fs/1000; %Length of frame
y=mod(length(speech),FrameLen);% last frame's length
m=length(speech);%length of speech
bolum=(m-y)/FrameLen; % number of frames
% Applying Hamming Window 
win = hamming(FrameLen);
% LPC Order
P=35;% P is the order of LPC and it calculated as 
     % P~Bandwidth(in KHz)*2+[2,3,4]
     % if BW=8 KHz P=2*8 +[2,3,4]=[18,19,20]
pitchFrequency=[]; % pitch periods for each frames
signalnew=[]; %resynthesized speech
tson=[]; % time for resynthesized speech
% Loop 
for i=0:1:bolum-1
speech1 = win.*speech((i)*FrameLen+1:(i+1)*FrameLen,1); %signal for one frame 
tframe=(0:length(speech1)-1)/fs;
% figure,plot(tframe,speech1)
% title(['Frame ', num2str(i+1)])
% Calculation of LPC coefficient (A) and Gain (G)
[A(:,i+1),G(i+1)] = lpc(speech1,P); 
% Pitch Detection
% Clipping the signal to Pitch Detection
speech2= clip_center(speech1);
% Moddified Autocorrelation Function is used to compute Autocorrelation
Rn(:,i+1)= modified_autocorrelation( speech2); % All values of Autocorrelation :Rn(k) for 0<=k<=N 
a=length(round(fs/350):round(fs/80)); % length of Fs/350<=k<=Fs/80 we take these interval 
                                      % because we only need to look in range
                                      % 80 Hz<=F0<=350Hz  
                                      % (80<=F0men<=200 and 150<=F0women<=350 )
Rnk(1:a,i+1)=Rn(round(fs/350):round(fs/80),i+1); % Rn(k) for Fs/350<=k<=Fs/80
[R(i+1),indis(i+1)]=max(Rnk(1:a,i+1)); %find max values at 80<f0<350 R=max{Rn(k)}
indis(i+1)=round(fs/350)-1+indis(i+1);%indices of max R values 
R0=Rn(1,:); % Rn(0)
Rn0=R0*0.3; %if R>=30% of Rn(0) then frame is voiced and pitch period= k+ Fs/350 else pitch period=0;
 k(i+1)=indis(i+1);
 if R(i+1)>=Rn0
       pitch(i+1)=(k(i+1)+fs/350); %frame is voiced
    else
       pitch(i+1)=0; % frame is unvoiced
    end
pitchFrequency=[pitchFrequency; pitch(i+1)]; %all pitch frequency
G(i+1)=G(i+1).*0.5.*10^3; % increase the gain to hear the new speech
[signal, t]=syn_lpc(fs,pitchFrequency(i+1),frame_dur,A(:,i+1),G(i+1)); %syntehize the signal by using syn_lpc function
signalnew=[signalnew;signal'];% syntehized the signal by collect all frames
tson=(0:length(signalnew)-1)/fs; %time duration for syntehized the signal

end
%figure,
subplot(2,1,1)
t1=(0:length(speech)-1)/fs; %time for the original signal
plot(t1,speech) %original signal
grid on
title ('Original Signal2')
subplot(2,1,2)
plot(tson,signalnew) %synthesized Signal
grid on
title('Synthesized Signal2')
%sound(signalnew,fs) %listen the synthesized Signal
wavwrite(signalnew,fs,'synthesized.wav')

