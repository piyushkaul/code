%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Gaussian Discriminant Analysis
% (c) Piyush Kaul. 2015EEY7544
% Ans 4. Assignment 1. 
% Feb 2016
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function GaussianDiscriminantAnalysis()
%Load the data X
load 'q4x.dat'
% Load the strings in q4y, which have 'Alaska' or 'Canada' per line.
str = fileread('q4y.dat');
ystr = strsplit(str);

% We assign 0 to Alaska and 1 to Canada.
for ix = 1:size(ystr,2)
    if strcmp(ystr{ix},'Alaska')
        q4y(ix) = 0;
    elseif strcmp(ystr{ix},'Canada')
        q4y(ix) = 1;
    end 
end 
q4y = q4y(:);
m = size(q4y,1);

% Find indices of y == 0 & y == 1 respectively.
zeroidx  = find(q4y == 0);
onesidx  = find(q4y == 1);

% Find mean for X correspionding with Y==0 & Y==1 respectively.
muzero = sum(q4x(zeroidx,:))/numel(zeroidx);
muones = sum(q4x(onesidx,:))/numel(onesidx);

% Substract respective mu0 and mu1 from the all the samples.
x0minusmu = q4x(zeroidx,:) - repmat(muzero,numel(zeroidx),1);
x1minusmu = q4x(onesidx,:) - repmat(muones,numel(onesidx),1);

% Combined vector with X corresponding to both y==0 and y==1
xtotal = [x0minusmu ; x1minusmu];

% Calculated Covariance Matrices for y==0, y==1, and combined.
xcovcommon = (1/m)*xtotal' * xtotal;
xcov0 = (1/(m*2))*x0minusmu' * x0minusmu;
xcov1 = (1/(m*2))*x1minusmu' * x1minusmu;

%% Equal Covariance Matrix Assumption
% plot the pdf contours assuming covariance is common across y==0 and y==1
figure;
[x,y] = meshgrid(0:10:200, 300:10:500);
xyval = [x(:) y(:)] ;
elemstoplot = size(xyval,1);
pdf0 = 1/(2*pi*sqrt(det(xcovcommon))) *  exp(-1/2 * sum((xyval - repmat(muzero,elemstoplot,1)) * inv(xcovcommon) .* (xyval - repmat(muzero,elemstoplot,1)),2));
pdf1 = 1/(2*pi*sqrt(det(xcovcommon))) *  exp(-1/2 * sum((xyval - repmat(muones,elemstoplot,1)) * inv(xcovcommon) .* (xyval - repmat(muones,elemstoplot,1)),2));
pdf0 = reshape(pdf0,size(x));
pdf1 = reshape(pdf1,size(x));
figure;
hold on
[c,h]=contour(x,y,pdf0,10,'r:');
[c,h]=contour(x,y,pdf1,10,'b:');
plot(q4x(zeroidx,1), q4x(zeroidx,2),'r+');
plot(q4x(onesidx,1), q4x(onesidx,2),'bo');

% Find out the X1 vs X2 by calculating X2 for various values of X1.
CX = (1/2) * (muzero * inv(xcovcommon) * muzero' - muones * inv(xcovcommon) *  muones');
PX = (muzero - muones)*inv(xcovcommon);

X1 = 80:160;
X2 = (CX - PX(1) * X1)./PX(2);

plot(X1,X2,'r-');
legend('contour pdf0','contour pdf1','Alaska', 'Canada','boundary');
title('GDA : Equal Sigma Case');
xlabel('x1');
ylabel('x2');
hold on;

%% Unqual Covariance Matrix Assumption

% Calculate pdf contours for P(x|y==1) and P(x|y==0) assuming different
% sigma0 and sigma1
pdf0 = 1/(2*pi*sqrt(det(xcovcommon))) *  exp(-1/2 * sum((xyval - repmat(muzero,elemstoplot,1)) * inv(xcov0) .* (xyval - repmat(muzero,elemstoplot,1)),2));
pdf1 = 1/(2*pi*sqrt(det(xcovcommon))) *  exp(-1/2 * sum((xyval - repmat(muones,elemstoplot,1)) * inv(xcov1) .* (xyval - repmat(muones,elemstoplot,1)),2));
pdf0 = reshape(pdf0,size(x));
pdf1 = reshape(pdf1,size(x));

figure(10);
hold on;
[c,h]=contour(x,y,pdf0,10,'r:');
[c,h]=contour(x,y,pdf1,10,'b:');
plot(q4x(zeroidx,1), q4x(zeroidx,2),'r+');
plot(q4x(onesidx,1), q4x(onesidx,2),'bo');
legend('contour pdf0','contour pdf1','Alaska', 'Canada');
title('GDA : Unequal Sigma Case');
xlabel('x1');
ylabel('x2');

A = inv(xcov0) - inv(xcov1);
B = inv(xcov0) * muzero' - inv(xcov1) * muones';
C = muzero*inv(xcov0)*muzero' - muones*inv(xcov1)*muones' + log(det(xcov0)) - log(det(xcov1));

a1 = A(1,1);
b1 = A(2,1) + A(1,2);
c1 = A(2,2);
d1 = 2*B(1);
e1 = 2*B(2);
f1 = C;
f = @(x1,x2) A(1,1).*x1.^2 + (A(2,1)+A(1,2)).*x1.*x2 + A(2,2).*x2.^2 - 2.*B(1).*x1 - 2.*B(2).*x2 + C;
h2 = ezplot(f,[0 200 300 500]);
title('GDA : Unequal Sigma Case');
Y = get(h2,'YData');
X = get(h2,'XData');
%plot(X,Y);
h2.Color = 'r';
h2.LineWidth = 2;



