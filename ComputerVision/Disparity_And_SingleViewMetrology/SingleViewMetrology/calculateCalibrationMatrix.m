function K=calculateCalibrationMatrix(vp)

x1 = vp(1,1);
x2 = vp(2,1);
x3 = vp(3,1);
y1 = vp(1,2);
y2 = vp(2,2);
y3 = vp(3,2);

solveOmegaMtx = [x1*x3+y1*y3  x1+x3   y1+y3;...
                 x1*x2+y1*y2  x1+x2   y1+y2;...
                 x2*x3+y2*y3  x2+x3   y2+y3];
b = [-1; -1; -1];
omegaVals = inv(solveOmegaMtx) * b;             

omega = [omegaVals(1)       0               omegaVals(2);...
         0                  omegaVals(1)    omegaVals(3);...
         omegaVals(2)       omegaVals(3)    1];
     
K   = chol(inv(omega));