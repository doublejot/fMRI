%------------------------------------------------------------------
function G = dualsort(A,B)
%  Balances choosing smaller variances with maintaining zero mean
%  A is vector of variances (always positive)
%  B is vector of means.
%  G is vector of index numbers for the dualsort order

%  Set a balancing parameter
%  BAL = 1 means Ordinary sort on variance alone
%  BAL = 1000  means just zero bias is considered
   BAL = 1.4;
  
n = length(A);
C = zeros(1,n);
meansum = 0;
for i = 1:n
    y = find(C==0);
    ymin = min(A(y));
    ylim = ymin*BAL + 0.00001;
    z = zeros(1,n);
    for j = 1:length(y)
        z(y(j)) = abs(meansum + B(y(j)));
    end
    meantemp = 1000;
    for j = 1:length(y)
        if A(y(j)) < ylim & z(y(j)) < meantemp
            jtemp = y(j);
            meantemp = z(y(j));
        end
    end
    C(jtemp) = i;
    meansum = meansum + B(jtemp);
end
[ gt, G ] = sort(C);

end