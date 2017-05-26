%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Decision Tree
% (c) Piyush Kaul. 2015EEY7544
% Ans 1. Assignment 3
% Apr 2016
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [attribute_id,partitions, medval] = get_best_atribute(traindata, mode)
global numerical_fields;
attribute_no = size(traindata,2);
medval = 0;
medval_array = zeros(1,11);
traindata_med = traindata;
if strcmp(mode,'raw')
    for field = numerical_fields
        medval  = median(traindata(:,field));
        traindata_med(:,field) = traindata(:,field) > medval;
        medval_array(field) = medval;
    end 
end

for attribute=2:attribute_no
    if numel(unique(traindata(:,attribute))) == 1
        entropy_measured(attribute) = 0;
    else
        entropy_measured(attribute) = get_entropy(attribute, traindata_med) ;
    end 
end

[val, attribute_id]  = max(entropy_measured);

medval = medval_array(attribute_id);
for ix=2:attribute_no   ux(ix) = numel(unique(traindata_med(:,ix))); end
if sum(ux(2:end)) == (attribute_no-1)
   partitions{1} = {traindata};
   return;
end 


uniq_vals = unique(traindata_med(:,attribute_id));
ix = 1;
partitions = {};
for val=uniq_vals(:)'
    [idxx,idyy] = find(traindata_med(:,attribute_id) == val);
    partitions{ix} = {traindata(idxx,:)};
    ix = ix + 1;
end 

fprintf('Best Attribute = %d, Partitions = %d, Etnropy = %f\n', attribute_id, numel(partitions), entropy_measured(attribute_id));
end

function entropy_meas = get_entropy(attribute, traindata)
numattribvals = max(traindata(:,attribute));
totalsamp = size(traindata,1);
entropy_meas = 0;
for attribval = 0:numattribvals
    [sidx, sidy] = find(traindata(:,attribute) == attribval);
    totvals = numel(sidy);
    onevals = numel(find(traindata(sidx,1) == 1));
    zerovals = numel(find(traindata(sidx,1) == 0));
    if onevals == 0 || zerovals == 0
        continue;
    else
        entr = -(onevals/totvals*log2(onevals/totvals) + zerovals/totvals*log2(zerovals/totvals));
        entropy_meas = entropy_meas +  totvals/totalsamp * entr; 
    end 
end
onevals = numel(find(traindata(:,1) == 1));
zerovals = numel(find(traindata(:,1) == 0));
totvals  = onevals+zerovals;

entr = -(onevals/totvals*log2(onevals/totvals) + zerovals/totvals*log2(zerovals/totvals));
entropy_meas = entr - entropy_meas; 
 
end 
