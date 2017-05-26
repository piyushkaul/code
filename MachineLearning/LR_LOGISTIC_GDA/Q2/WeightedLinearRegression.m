%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Weighted Linear Regression
% (c) Piyush Kaul. 2015EEY7544
% Ans 2. Assignment 1. 
% Feb 2016
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear;

%% Load x and y
load 'q3y.dat'
load 'q3x.dat'


m = length(q3x);

%% Append ones to create intercept term
X = [q3x  ones(m,1)];

%% Least Squares
theta = (X' * X) \ X' * q3y;

% Least Square  Plot
figure;
plot(q3x,q3y,'r.');
xpoints=min(q3x):0.1:max(q3x);
ypoints = theta(1) * xpoints + theta(2);
hold on;
plot(xpoints, ypoints, 'b-');


x=q3x;

% TAU
tau = 0.8;

%% Weightted Least Squares
for ix=1:m
    xi = q3x(ix);
    w=exp(-(x-xi).^2 /(2*tau^2));
    W = diag(w);
    theta = (X' * W * X) \ X' * W * q3y;
    yhat(ix) = X(ix,:) * theta;
end          

% Plotting
hold on;
plot(q3x, yhat, 'g+');
title(['Weighted Least Squares with Tau=' num2str(tau)]);
xlabel('X');
ylabel('Y')
legend('data','linear regression','weighted linear regression');