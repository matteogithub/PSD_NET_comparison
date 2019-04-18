function PLV=PLV(a)
% a is a filtered multichannel signal (time x channels)
N=size(a,2);
PLV(1:N,1:N)=0;
complex_a=hilbert(a);
for i=1:N
    for j=1:N
        if i<j
        PLV(i,j)=abs(mean(exp(1i*(angle(complex_a(:,i))-angle(complex_a(:,j)))),1));
        PLV(j,i)=PLV(i,j);     
        end
    end
end