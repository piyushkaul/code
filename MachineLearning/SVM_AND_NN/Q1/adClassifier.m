function adClassifier()
close all;
clear all;

opt1 = 0;
run 'cvx/cvx_setup';

m = 2500;
[X,Y, avgval] = ReadDataFile('train.data', m, opt1, []);
avgx = mean(X,2) ;
maxx = max(X,[],2);
idxzero = find(maxx == 0);
maxx(idxzero) = 1;
X = (X-repmat(avgx,1,m))./repmat(maxx,1,m);
COVX  = X' * X;
Y = Y(:);
for ix=1:m
    for jx=1:m
        QX(ix,jx) = X(:,ix)' * X(:,jx');
    end
end
if ~exist('alphax.mat','file')
cvx_begin
variables alphax(m)
alphaxy = alphax .* Y;
maximize(sum(alphax) - 1/2* alphaxy'*QX*alphaxy);
subject to 
    0<= alphax <= 1;
    alphax' * Y == 0;
cvx_end
    save('alphax.mat','alphax');
else
    load 'alphax.mat'
end 
W= X* (alphax.*Y);
idx0=find(Y==-1);
idx1=find(Y==1);
wx=W'*X;
maxoveri0 = max(wx(idx0));
minoveri1 = min(wx(idx1));
bstar = -(maxoveri0 + minoveri1)/2;
est=(W'*X+bstar)>0;
est = 2*est - 1;

mTest = 779;
[XTest,YTest] = ReadDataFile('test.data', mTest, 0, avgval);
XTest = (XTest-repmat(avgx,1,mTest))./repmat(maxx,1,mTest);

YTest = YTest(:);
estTest = [];
estTest = (W'*XTest + bstar)>0;
estTest = 2*estTest - 1;
estTest = estTest(:);
ErrorNum = sum(YTest~=estTest(:));
CorrectNum = sum(YTest == estTest);
fprintf('With Linear Kernel : Errors = %d, Correct %d Detection Rate =%d%%\n', ErrorNum, CorrectNum, CorrectNum/length(YTest)*100);

gamma = 2.5e-4;
QX2 = zeros(m,m);
for ix = 1:m
    for jx = 1:m
        QX2 = exp(-gamma*sum((X(:,ix)-X(:,jx)).^2))/2;
    end 
end 
if ~exist('alphax2.mat','file')
cvx_begin
variables alphax2(m)
alphaxy2 = alphax2 .* Y;
maximize(sum(alphax2) - 1/2* alphaxy2'*QX2*alphaxy2);
subject to 
    0<= alphax2 <= 1;
    alphax2' * Y == 0;
cvx_end
    save('alphax2.mat','alphax2');
else
    load 'alphax2.mat'
end 

W2= X* (alphax2.*Y);
idx3=find(Y==-1);
idx4=find(Y==1);
wx2=W2'*X;
maxoveri3 = max(wx2(idx3));
minoveri4 = min(wx2(idx4));
bstar2 = -(maxoveri3 + minoveri4)/2;
estTest2 = [];

estTest2 = (W2'*XTest + bstar2)>0;
estTest2 = 2*estTest2 - 1;
estTest2 = estTest2(:);
ErrorNum2 = sum(YTest~=estTest2(:));
CorrectNum2 = sum(YTest == estTest2);
fprintf('With Gaussian Kernel : Errors = %d, Correct %d Detection Rate =%d%%\n', ErrorNum2, CorrectNum2, CorrectNum2/length(YTest)*100);

addpath 'libsvm-3.21/matlab'
disp('********* libSVM For Linear Kernel ***********')
model1 = svmtrain(Y,X','-t 0 -s 0 -c 1 ');
[predicted_label1] = svmpredict(YTest,XTest',model1);

disp('********* libSVM For Gaussian Kernel ***********')
model2 = svmtrain(Y,X','-t 2 -s 0 -c 1 -g 2.5e-4');
[predicted_label2] = svmpredict(YTest,XTest',model2);




end

function [X, Y, avgval] = ReadDataFile(filename, m, opt1, avgval)

pos = 0;
fid = fopen(filename);

for lin=1:m
    str = fgets(fid);
    str = strrep(str,'?','0');
    [C{lin},pos] = textscan(str,'%f,');
    [D{lin},pos] = textscan(str(pos+1:end),'%s.\n');    
end

fclose(fid);

for lin=1:m
    X(:,lin) = C{lin}{1};
    Y(:,lin) = 1-2*strcmp(D{lin}{1},'nonad.');
end

if opt1
    if isempty(avgval)
       
        avgval = mean(X,2);
        idxQ = find(X(1,:) == 0);
    
        X(1,idxQ) = avgval(1);
        X(2,idxQ) = avgval(2);
        X(3,idxQ) = avgval(2);
    else
        idxQ1 = find(X(1,:) == 0);
        X(1,idxQ1) = avgval(1);
        X(2,idxQ1) = avgval(2);
        X(3,idxQ1) = avgval(3);
    end 
    
else
    avgval = [];
end 

end


