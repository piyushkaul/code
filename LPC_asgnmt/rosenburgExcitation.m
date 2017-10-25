function [glot] = rosenburgExcitation(N1,N2)
glot = zeros(N1+N2+1,1);
glot(1:N1) = 1/2*(1-cos(pi*(0:(N1-1))/N1));
glot(N1+1:N1+N2+1) = cos(pi*((N1:N1+N2)-N1)/(2*N2));
