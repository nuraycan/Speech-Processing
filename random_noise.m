% Random_noise Generator
function [ noise ] = random_noise( srate,frame_dur )
Frame_Len=srate.*frame_dur./1000;
noise = wgn(Frame_Len, 1, 10, 'real');
end

