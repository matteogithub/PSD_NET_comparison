function [Yorth]=orthog_timedomain(X,Y)
R=[ones(length(X),1) X] \ Y;
Ypred=X*R(2);
Yorth=Y-Ypred;