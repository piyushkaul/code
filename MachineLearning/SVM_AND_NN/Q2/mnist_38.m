function  mnist_38()
load mnist_all.mat

trainim = [train3 ; train8];
testim = [test3; test8];
trainlabel = [zeros(1,size(train3,1)) ones(1,size(train8,1))];
testlabel = [zeros(1,size(test3,1)) ones(1,size(test8,1))];


save('mnist_bin38.mat', 'trainim', 'testim', 'trainlabel', 'testlabel');

imgs=load('mnist_bin38.mat');
[m,n] = size(imgs.trainim);

w1 = 0.001*randn(n,100);
w2 = 0.001*randn(100,1);
trainingset = double(imgs.trainim);
label = imgs.trainlabel;
testset = double(imgs.testim);
testlabel = imgs.testlabel;
numim = length(testlabel);
seq = randperm(m);
alpha = 0.01;

for iter=1:100
tic
    eta = alpha/sqrt(iter);
    trainerror = 0;
    for seqno = seq
        xd =  trainingset(seqno,:);
        net1 = xd * w1;
        h1 = sigmoid(net1);
        net2 = h1 * w2;
        o2 = sigmoid(net2);
        err = label(seqno) - o2;
        if(abs(err) > 0.5)
            trainerror = trainerror + 1;
        end 
        deltak  = err*(o2)*(1-o2);
        w2 = w2 + eta*deltak* h1';
        deltaj  = sum(deltak)* w2 .* h1' .* (1-h1)';
        w1 = w1 + eta* (deltaj * xd)';
    end 
    trainerr(iter) = trainerror/length(seq);
    
    for ix=1:numim;
        xd =  testset(ix,:);
        net1 = xd * w1;
        h1 = sigmoid(net1);
        net2 = h1 * w2;
        o2 = sigmoid(net2);
        det(ix) = o2;        
    end
    est = det>0.5;
    errors = sum(est ~= testlabel);
    testerr(iter) = errors/numim;
    figure(1); plot(est,'bo');hold on;plot(testlabel,'r-');
    axis([0 length(testlabel) -1 2]);
    drawnow;
    figure(4); plot(testerr,'r-');hold on;plot(trainerr,'b-');    
    legend('test error', 'train error')
    title('MNIST with 3 and 8');
    drawnow;
    fprintf('iter = %d, errors = %d, total = %d\n', iter, errors, numim);
    if iter > 6
    if testerr(end) >= mean(testerr(end-5:end-1))
        break
    end 
    end 
toc
end

end
function y = sigmoid(x)
    y = 1./(1+exp(-x));
end
