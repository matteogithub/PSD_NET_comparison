function AEC=AEC(a)
% a is a filtered multichannel signal (time x channels)

N=size(a,2);
AEC(1:N,1:N)=0;
complex_a=hilbert(a);

for i=1:N
    for j=1:N
        if i<j
        
        ort1=orthog_timedomain(a(:,i),a(:,j));
        complex_ort1=abs(hilbert(ort1));
        AEC1=abs(corrcoef(complex_ort1,abs(complex_a(:,i))));
        
        ort2=orthog_timedomain(a(:,j),a(:,i));
        complex_ort2=abs(hilbert(ort2));
        AEC2=abs(corrcoef(complex_ort2,abs(complex_a(:,j))));
        
        AEC_mean=(AEC1(1,2)+AEC2(1,2))/2;
        
        AEC(i,j)=AEC_mean;          
        
        
        AEC(j,i)=AEC(i,j);
        
        end
        
    end
end

end