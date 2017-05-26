%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Naive Bayes
% (c) Piyush Kaul. 2015EEY7544
% Ans 2. Assignment 3
% Apr 2016
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [counts, class_prob, dictionary] = naive_parse_training(entire_doc, train_idxes, newsgroups)
dictionary = containers.Map;

for idx=1:numel(train_idxes)
    str = entire_doc{train_idxes(idx)};   
    temp = textscan(str,'%s','Delimiter',' \t');
    for ix=1:length(temp{:})
        dictionary(temp{1}{ix})  = 0;
    end
end 

keySet=keys(dictionary);

for grp=1:numel(newsgroups)
    counts{grp} = containers.Map;
    for keyVal = 1:numel(keySet)
        counts{grp}(keySet{keyVal}) = 0;
    end 
end

total_docs = zeros(1,8);
for idx=1:numel(train_idxes)
    str = entire_doc{train_idxes(idx)};   
    temp = textscan(str,'%s','Delimiter',' \t');
    IndexC=strfind(newsgroups,temp{1}{1});
    Index = find(not(cellfun('isempty', IndexC)));
    total_docs(Index) = total_docs(Index) + 1;
    for ix=1:length(temp{:})
        counts{Index}(temp{1}{ix})  = counts{Index}(temp{1}{ix}) + 1;
    end
end 

for grp=1:numel(newsgroups)
    for keyIdx = 1:numel(keySet)
        counts{grp}(keySet{keyIdx}) = log((counts{grp}(keySet{keyIdx})+1)/(total_docs(grp)+numel(newsgroups)));        
    end
end

class_prob = log(total_docs/sum(total_docs));
