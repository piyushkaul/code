function  [lpCoeffs, refCoeff, res] = findLPCoeffsLevinson(inFrame,order)

%find autocorrelation
rx = zeros(1,order+1);
for lag=0:order
    for sample=1:(length(inFrame) - lag)
        rx(lag+1) = rx(lag+1) + inFrame(sample) * inFrame(sample+lag);
    end
    %rx(lag+1)  = rx(lag+1)/length(inFrame);
end
rx = rx/(length(inFrame)-1);

%Initialize 
P = zeros(11,1);
P(1) = rx(1); 
Beta = zeros(11,1);
Beta(1) = conj(rx(2));
k = zeros(10,1);
k(1) = -conj(rx(2))/rx(1); 
a = zeros(10,10);
a(1,1) = k(1);

%iteration
for m =2:(order)
    P(m) = P(m-1) + Beta(m-1)*conj(k(m-1));
    rm = rx(2:m)';
    Beta(m) = a(1:(m-1),m-1)' * flipud(fliplr(conj(rm))) + rx(m+1);
    k(m) = - Beta(m)/P(m);
    
    a(1:m,m) = [a((1:m-1),m-1);0] + [flipud(conj(a(1:m-1,m-1)));1] * k(m);
end    

P(order+1) = P(order) + Beta(order) * conj(k(order));
lpCoeffs = a(1:order,order);
refCoeff = k;

outFrame = filter(1,lpCoeffs,inFrame);
res = inFrame - outFrame;    