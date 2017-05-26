%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Naive Bayes
% (c) Piyush Kaul. 2015EEY7544
% Ans 2. Assignment 3
% Apr 2016
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [detection_percentage, confusion_matrix] = naive_testing(entire_doc, test_idxes, newsgroups, prob, class_prob, dictionary)

lprob =prob;
lclass_prob =class_prob;
keySet=keys(dictionary);
correct = 0;
error = 0;
confusion_matrix = zeros(numel(newsgroups),numel(newsgroups));

total_docs = zeros(1,8);
for idx=1:numel(test_idxes)
    test_case = containers.Map;
    str = entire_doc{test_idxes(idx)};   
    temp = textscan(str,'%s','Delimiter',' \t');
    IndexC=strfind(newsgroups,temp{1}{1});
    Index = find(not(cellfun('isempty', IndexC)));
    
    for ix=1:length(temp{:})-1
        test_case(temp{1}{ix+1})  = 1;
    end
    keySetTest=keys(test_case);
    likelihood = zeros(1,numel(newsgroups));
    for grp=1:numel(newsgroups)
        for keyIdx = 1:numel(keySetTest)    
            if isKey(lprob{grp},keySetTest(keyIdx))
                likelihood(grp) = likelihood(grp) + lprob{grp}(keySetTest{keyIdx});        
            end 
        end
        likelihood(grp) = likelihood(grp) + lclass_prob(grp);
    end
    [val,idx]=max(likelihood);
    if(idx == Index)
        correct = correct + 1;
        fprintf('Correct %d\n', idx);
    else
        error = error + 1;
        fprintf('Incorrect Detected=%d, Label=%d\n', idx, Index);
        
    end 
    confusion_matrix(idx,Index) = confusion_matrix(idx,Index) + 1;        
end 
detection_percentage = correct/(correct+error)*100;
fprintf('Detected = %f\n', correct/(correct+error))