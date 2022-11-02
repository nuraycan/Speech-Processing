% Moddified Autocorrelation Function
function [ Rn ] = modified_autocorrelation( speech1 )
N=length(speech1);

for k=0:N
for m=1:N-k
    a(m,k+1)=speech1(m)*speech1(m+k);
  if speech1(m)==speech1(m+k)
     a(m,k+1)=1;
  elseif speech1(m)~=speech1(m+k)
     a(m,k+1)=-1;
  elseif speech1(m)==0 || speech1(m+k)==0
    a(m,k+1)=0;
    
  end
  Rn(k+1)=sum(a(:,k+1));
end
end
end

