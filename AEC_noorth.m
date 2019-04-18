function AEC=AEC_noorth(a)
% a is a filtered multichannel signal (time x channels)

N=size(a,2);
AEC(1:N,1:N)=0;
complex_a=hilbert(a);

for i=1:N
    for j=1:N
        if i<j        

        AEC1=abs(corrcoef(abs(complex_a(:,j)),abs(complex_a(:,i))));        
        AEC_mean=AEC1(1,2);        
        AEC(i,j)=AEC_mean;       
        AEC(j,i)=AEC(i,j);
        
        end
        
    end
end

end