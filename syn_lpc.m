% LPC Synthesizer
function [signal,t]=syn_lpc(srate,f0,frame_dur,A,G)
if f0~=0
    y  = impulsetrain( srate,f0,frame_dur);%voiced parts
else
    y=random_noise( srate,frame_dur);% unvoiced parts
    y=y'; % make all of them column vectors
end
signal= filter(G,A',y); %filters the data in vector y with the
                        %filter described by vectors A' and G to create the filtered data signal.
t =(0:length(signal)-1)/srate;
end
