function pli=wpli_sin(data)
[nc, ns, nt]=size(data);

phs=angle(data);

pli=zeros(nc, nc, nt);

for t=1: nt
    tpli = complex(zeros(nc));
    for s=1: ns
        dphs=bsxfun(@minus, phs(:, s, t), phs(:, s, t)');
        tpli=tpli+abs(sin(dphs))./sin(dphs);
    end
    pli(:,:, t)=abs(tpli / ns);
end