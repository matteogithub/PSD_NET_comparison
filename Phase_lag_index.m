    function PLI=Phase_lag_index(a)

% a is a filtered multichannel signal (time x channels)
% hilbert(a) calculates analytic signal (complex valued) of each
% column of a. Phase Lag Index between channel i and j averaged over
% time bins is stored in PLI(i,j)
% number of channels
N=size(a,2);
PLI(1:N,1:N)=0;
complex_a=hilbert(a);
complex_aa=angle(hilbert(a));

for i=1:N
    for j=1:N
        if i<j
        PLI(i,j)=abs(mean(sign(sin(complex_aa(:,i)-complex_aa(:,j)))));
        PLI(j,i)=PLI(i,j);     
        end
    end
end
