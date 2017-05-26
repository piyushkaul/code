function  mnist_alldigits()
load mnist_all.mat

num_hidden_neurons = 1000;
batchSize=1;
alpha = 0.01;

trainim = [train0; train1; train2; train3; train4; train5; train6; train7; train8; train9];
testim  = [test0;  test1;  test2;  test3;  test4;  test5;  test6;  test7;  test8;  test9];

trainlabel = [0*ones(1,size(train0,1)), 1*ones(1,size(train1,1)), 2*ones(1,size(train2,1)), ...
              3*ones(1,size(train3,1)), 4*ones(1,size(train4,1)), 5*ones(1,size(train5,1)), ...
              6*ones(1,size(train6,1)), 7*ones(1,size(train7,1)), 8*ones(1,size(train8,1)), ...
              9*ones(1,size(train9,1)) ];
testlabel = [0*ones(1,size(test0,1)), 1*ones(1,size(test1,1)), 2*ones(1,size(test2,1)), ...
             3*ones(1,size(test3,1)), 4*ones(1,size(test4,1)), 5*ones(1,size(test5,1)), ...
             6*ones(1,size(test6,1)), 7*ones(1,size(test7,1)), 8*ones(1,size(test8,1)), ...
             9*ones(1,size(test9,1))];


save('mnist_binall.mat', 'trainim', 'testim', 'trainlabel', 'testlabel');

imgs=load('mnist_binall.mat');
[m,n] = size(imgs.trainim);



w1 = 0.01*randn(n,num_hidden_neurons);
w2 = 0.01*randn(num_hidden_neurons,10);
trainingset = double(imgs.trainim);
trainlabel = imgs.trainlabel;
testset = double(imgs.testim);
testlabel = imgs.testlabel;
numim = length(testlabel);


for iter=1:1000
tic 
    seq = randperm(m);
    eta = alpha/sqrt(iter);
    ix = 0;
    toterr=0;
    for idx=1:batchSize:m
        seqno = seq(idx:idx+batchSize-1);
        % First Layer Forward
        xd =  trainingset(seqno,:);
        net1 = xd * w1;
        h1 = sigmoid(net1);
        % Second Layer Forward
        net2 = h1 * w2;
        o2 = sigmoid(net2);
        
        %Error Calcu lation
        label_vec = zeros(batchSize,10);
        label = trainlabel(seqno);
        indices = sub2ind(size(label_vec), 1:batchSize,label+1);
        label_vec(indices) = 1;
        err = label_vec - o2;
      [res,idxmax]=max(o2,[],2);
        toterr = toterr + sum((label+1) ~= idxmax');
        ix = ix+batchSize;
        %Backpropagation        
        deltak  = err.*(o2).*(1-o2);
        w2 = w2 + (1/batchSize)*(eta * deltak' * h1)';
        deltaj = deltak * w2' .* h1 .* (1-h1);
        w1 = w1 + (1/batchSize)*eta* (deltaj' * xd)';
    end 
    avgerr = toterr/ix;
 
    
    for ix=1:batchSize:numim;
        xd =  testset(ix:ix+batchSize-1,:);
        net1 = xd * w1;
        h1 = sigmoid(net1);
        net2 = h1 * w2;
        o2 = sigmoid(net2);
        det(ix:ix+batchSize-1, :) = o2;        
    end
    
    [est,idx] = max(det,[], 2);
    errors = sum(idx' ~= (testlabel+1));
    %figure(1); plot(est,'bo');hold on;plot(testlabel,'r-')
    %axis([0 length(testlabel) -1 2]);
    %drawnow;
    fprintf('iter = %d, errors = %d, total = %d\n', iter, errors, numim);
    testerror(iter) = errors/numim;
    trainerror(iter) = avgerr;
    figure(1); plot(testerror,'r-'); hold on; plot(trainerror,'b-');
    legend('test error', 'train error');
    title('Neural Network All Digits');
    drawnow;
    if iter > 6
        if testerror(end) >= mean(testerror(end-5:end-1))
         %   break
        end 
    end 
    toc 
end
end
function y = sigmoid(x)
    y = 1./(1+exp(-x));
end
