%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Naive Bayes
% (c) Piyush Kaul. 2015EEY7544
% Ans 2. Assignment 3
% Apr 2016
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

progresive = 0;
fid = fopen('nb/20ng-rec_talk.txt');
newsgroups = {'rec.autos', 'rec.motorcycles', 'rec.sport.baseball','rec.sport.hockey' ...
    'talk.politics.guns', 'talk.politics.mideast', 'talk.politics.misc', 'talk.religion.misc'};
%1,1,female,35.0,1,0,36973.0,83.475,S,C,83.0
itr = 1;
idx = 1;

while 1
    str = fgets(fid);   
    if str == -1
        break;
    end
    entire_doc{idx} = str;
    idx = idx + 1;
end 
num_docs = idx - 1;
split_size = num_docs/5;
randidxes = randperm(num_docs);
train_example_idx  = 0;
if progresive
     num_train_examples = [1000:1000:split_size*4 split_size*4];
else
    num_train_examples = [split_size*4];
end
for train_example_idx = 1:numel(num_train_examples)
    train_examples = num_train_examples(train_example_idx);
    
for crossno = 0:4
    test_idxes = randidxes(split_size*(crossno)+1:split_size*(crossno+1));
    train_idxes = setdiff(randidxes,test_idxes);
    train_idxes_used = train_idxes(1:train_examples);
    %if ~exist(['parse_out_store' num2str(crossno) '.mat'],'file')
        [prob, class_prob, dictionary] = naive_parse_training(entire_doc, train_idxes_used, newsgroups);
    %    save(['parse_out_store' num2str(crossno)],'prob','class_prob','dictionary');
    %else
    %    load(['parse_out_store' num2str(crossno)]);
    %end 
    [detection_percentage(train_example_idx, crossno+1),confusion_matrix_list{train_example_idx,crossno+1}] = naive_testing(entire_doc, test_idxes, newsgroups, prob, class_prob, dictionary);
    
    
end 
end

for train_example_idx=1:numel(num_train_examples)
for crossno = 0:4
fprintf('Detection Percentage for Training Examples =%d Cross Validation Set No = %d was %f\n',num_train_examples(train_example_idx),crossno, detection_percentage(train_example_idx, crossno+1));
end 
fprintf('Mean Detection Percentage was %f\n', mean(detection_percentage(train_example_idx,:)));
end
res = mean(detection_percentage,2);
figure;plot(num_train_examples,res,'r');
title('detection percentage vs number of training examples');
xlabel('number of training samples');
ylabel('detection percentage');

conf = zeros(size(confusion_matrix_list{1,1}));
for crossno=0:4
    conf = conf + confusion_matrix_list{1,crossno+1};
end 
confusion_matrix_final = round(conf./5)