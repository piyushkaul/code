%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Logistic Regression and Newton Rhapson
% (c) Piyush Kaul. 2015EEY7544
% Ans 3. Assignment 1. 
% Feb 2016
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;

% Load x and y
load q2x.dat;
load q2y.dat;

% Normalize q2x
q2x = (q2x - repmat(mean(q2x),size(q2x,1),1))./(repmat(var(q2x),99,1));
q2x = [q2x ones(size(q2x,1),1)];
theta = [0 ; 0; 0];
n = size(q2x, 2);
m = size(q2x, 1);

%% Do Newton Rhapson iteration
for iter = 1:1000
    % Calculate hessian
    g_theta_x = 1./(1+exp(-theta'*q2x'));
    prod_gtheta_term = g_theta_x  .* (1-g_theta_x);
    for ix=1:n
          for jx=1:n
               hesstheta(ix,jx) =  -1* sum(q2x(:,ix) .* q2x(:,jx) .* prod_gtheta_term' );           
         end 
    end 
    
    % detla_theta is first derivative of theta
    delta_theta = 1/m * sum((q2y - q2x * theta) * ones(1,n) .* q2x, 1);
    
    % Update theta
    theta = theta - inv(hesstheta) * delta_theta';
    theta_iter(:,iter) = theta;
    fprintf('iter = %d, theta1 = %f, theta2 = %f, theta3 = %f\n', iter, theta(1), theta(2), theta(3));
    if(iter~=1 && norm(theta - theta_iter(:,iter-1)) < eps)
        fprintf(1,'converged\n');
        break;
    end 
    
end 

%Plotting
figure;plot(theta_iter');
title('convergence speed');
legend('theta2','theta1','theta0');
estimates = q2x * theta;
pos = find(estimates > 0.5);
neg = find(estimates < 0.5);

figure;plot(q2x(pos,1),q2x(pos,2),'r+');
hold on;plot(q2x(neg,1),q2x(neg,2),'bo');
x1points = -1.5:0.1:1.5;
x2points = (0.5 - theta(3) - x1points * theta(1))/ theta(2);
plot(x1points,x2points,'k--');
legend('positive','negative','boundary');
title('decision boundary');
xlabel('x1');
ylabel('x2');
