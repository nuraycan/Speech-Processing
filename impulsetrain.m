% Impulse Train Generator
function [ y ] = impulsetrain( srate,f0,frame_dur)
 f=f0; %pitch frequency of a frame 
 fs=srate; % sample rate
 framelen=fs*frame_dur/1000;
 n=0:1:framelen;% time vector
 y=zeros(size(n));
 y(1:f:length(y))=1;
end

