function ic=icoh2(a)
% a is a filtered multichannel signal (time x channels)
N=size(a,2);
ic(1:N,1:N)=0;
complex_a=hilbert(a);
ph=angle(complex_a);
for i=1:N
    for j=1:N
        if i<j
            A1=abs(a(:,i));
            A2=abs(a(:,j));
            ic(i,j)=abs((sum(A1.*A2.*sin(ph(:,i)-ph(:,j)))/size(a,1))/sqrt((sum(A1.*A1)/size(a,1))*(sum(A2.*A2)/size(a,1))));
            ic(j,i)=ic(i,j);
        end
    end
end

