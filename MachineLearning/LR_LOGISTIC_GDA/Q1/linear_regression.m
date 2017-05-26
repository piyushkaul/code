%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Linear Regression
% (c) Piyush Kaul. 2015EEY7544
% Ans 1. Assignment 1. 
% Feb 2016
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;

% Load X and Y
load q1x.dat 
load q1y.dat

m = length(q1x);
q1x = q1x - mean(q1x);
q1x = q1x/(std(q1x));


%% Parameters
slowplot = 1;% slowplot will show plotting updates with pauses
theta = [0; 0]; % 2 parameter per iteration corresponding to q1x and intercept.
eta = 0.1; % Learning rate
iter = 1; % initialize iterations by 1
convergence_threshold = 0.0001; % if the difference is less than this, we exit the loop
stdout = 1; % Print to stdout

%% Plot the error surface
m = length(q1x);
if (slowplot)
     [theta1d,theta2d] = meshgrid(-2:0.1:10, -2:0.1:10);
     theta1dummy = theta1d(:);
     theta2dummy = theta2d(:);
     for idx=1:length(theta1dummy)
        errdummy(idx) = 0;
        thetadummy = [theta1dummy(idx); theta2dummy(idx)];         
        for kdx=1:m
           xvec = [q1x(kdx); 1];
           errdummy(idx) = errdummy(idx) + (q1y(kdx) - thetadummy' * xvec).^2;
        end 
        errdummy(idx)  = 1/(2*m) * errdummy(idx);          
     end 
     errdummy = reshape(errdummy,size(theta1d));
     figure(1);
     %subplot(1,2,1);
     title(['error surface eta=' num2str(eta)]);
     hold on;
     surf(theta1d, theta2d, errdummy);     
    %subplot(1,2,2);
     figure(2)
     contour(theta1d, theta2d, errdummy, 100);
     title(['error contour eta=' num2str(eta)]);
     hold on;

end 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Iterations Loop
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
while 1
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Batch Loop. We go over all samples
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    errvec = zeros(2,1);
    jtheta(iter) = 0;
    for idx=1:m
        xvec = [q1x(idx); 1];
        errvec = errvec + (q1y(idx) - theta(:,iter)' * xvec)* xvec;        
        jtheta(iter) = jtheta(iter) + (q1y(idx) - theta(:,iter)' * xvec).^2;
    end  
    jtheta(iter) = 1/(2*m) *  jtheta(iter);
    if(slowplot)
        figure(1);
        hold on;
        %subplot(1,2,1)
        figure(1);
        plot3(theta(1,:), theta(2,:), jtheta(:),'r.-');
        %subplot(1,2,2)
        figure(2);
        plot3(theta(1,:), theta(2,:), jtheta(:),'r.-');        
        %[theta(1,iter), theta(2,iter), jtheta(iter)]
        pause(0.2);
    end 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Update Theta
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    theta(:,iter+1) = theta(:,iter) + eta * 1/m * errvec;
    
    fprintf(stdout, 'iter = %d, theta1 = %f, theta2 = %f, errvec1 = %d errvec2 = %d\n', iter, theta(1,iter+1), theta(2,iter+1), errvec(1), errvec(2));
    
    if (norm(theta(:,iter+1) - theta(:,iter))) < convergence_threshold
        fprintf(stdout, 'Converged! exiting loop\n');
        break;
    end 
    iter = iter + 1;    
    
end 

%Plotting the Linear Fit.
figure;

plot(q1x,q1y,'r.');
xlabel('X');
ylabel('Y');
title ('Linear Regression Fitting');
xpoints=min(q1x):0.1:max(q1x);
ypoints = theta(1,end) * xpoints + theta(2,end);
hold on;
plot(xpoints, ypoints, 'b:');


