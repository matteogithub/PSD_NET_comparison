function [pli,wpli]=wpli_sin(data)
[nc, ns, nt]=size(data); %here data is the Hilbert transform already

phs=angle(data);

pli=zeros(nc, nc, nt);wpli=pli;

for t=1: nt
    tpli = complex(zeros(nc));
    tpli_num = complex(zeros(nc));
    tpli_den = complex(zeros(nc));
    for s=1: ns
        dphs=bsxfun(@minus, phs(:, s, t), phs(:, s, t)');
        tpli=tpli+abs(sin(dphs))./sin(dphs);
        tpli_den=tpli_den+abs(sin(dphs));
        tpli_num=tpli_num+sin(dphs);
    end
    pli(:,:, t)=abs(tpli / ns);
    wpli(:,:, t)=abs(tpli_num/ns)./(abs(tpli_den)/ ns); 
end
