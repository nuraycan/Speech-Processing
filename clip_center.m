% Clipping function
function speech1= clip_center(speech1) 
N=length(speech1);
cliplevel = max(speech1).*0.3; % 30 percent of max(speech1)
for j = 1:N
  if (speech1(j)) > cliplevel
    speech1(j) = 1;
  elseif (speech1(j)) < cliplevel
      speech1(j) = -1;
  else
      speech1(j) = 0;
  end
end
end

