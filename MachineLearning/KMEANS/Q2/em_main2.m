function em_main2()

addpath('data_EM');

%% Training and Test Data File read
filename = 'train.data';
train_full = em_read_data(filename);
filename = 'test.data';
test_data = em_read_data(filename);
filename = 'train-m1.data';
train_m1 = em_read_data(filename);
filename = 'train-m2.data';
train_m2 = em_read_data(filename);

%% For No Parameter Missing %%

list_likelihoods1 = calculate_full_data(train_full);
ll = calculate_ml(list_likelihoods1, test_data);
disp(['Log Likelihood Full' num2str(ll)]);

fprintf('Maximum Likelihood\n');
for ix = 1:5
sz = size(list_likelihoods1{ix});
fprintf('Param %d\n', ix);    
for rows=1:sz(1)
    fprintf('%d \t', list_likelihoods1{ix}(rows,:));
    fprintf('\n');
end 
fprintf('-----------------------------\n');
end

%% For Single Parameter Missing %%

list_likelihoods2 = calculate_missing_data(train_m1);
ll2 = calculate_ml(list_likelihoods2, test_data);
disp(['ML: Log Likelihood Incomplete Data: Single Missing' num2str(ll2)]);

[list_likelihoods3, filled] = calculate_em(train_m1, list_likelihoods2);
ll3 = calculate_ml(list_likelihoods3, test_data);
disp(['EM : Log Likelihood Filled Data: Single Missing' num2str(ll3)]);

%% For Double Parameter Missing %%

list_likelihoods4 = calculate_missing_data(train_m2);
ll4 = calculate_ml(list_likelihoods4, test_data);
disp(['ML: Log Likelihood Incomplete Data: Single Missing' num2str(ll4)]);

[list_likelihoods5, filled] = calculate_em_double(train_m2, list_likelihoods4);
ll5 = calculate_ml(list_likelihoods5, test_data);
disp(['Log Likelihood EM Filled Data: Double Missing' num2str(ll5)]);

end


function list_likelihoods = calculate_full_data(data)

h1 = calculate_wo_missing(data, 1, []);
b1 = calculate_wo_missing(data, 2, 1);
l1 = calculate_wo_missing(data, 3, 1);
x1 = calculate_wo_missing(data, 4, 3);
f1 = calculate_wo_missing(data, 5, [2 3]);

list_likelihoods{1} = h1;
list_likelihoods{2} = b1;
list_likelihoods{3} = l1;
list_likelihoods{4} = x1;
list_likelihoods{5} = f1;
end

function list_likelihoods = calculate_missing_data(data)

h2 = calculate_with_missing(data, 1, []);
b2 = calculate_with_missing(data, 2, 1);
l2 = calculate_with_missing(data, 3, 1);
x2 = calculate_with_missing(data, 4, 3);
f2 = calculate_with_missing(data, 5, [2 3]);


list_likelihoods{1} = h2;
list_likelihoods{2} = b2;
list_likelihoods{3} = l2;
list_likelihoods{4} = x2;
list_likelihoods{5} = f2;

end

function ll_sum = calculate_ml(list_likelihoods, test_set)
    ll_sum = 0;
    for idx = 1:size(test_set,1)
         ll = log(list_likelihoods{1}(test_set(idx,1)+1));
         ll = ll + log(list_likelihoods{2}(test_set(idx,1)+1,test_set(idx,2)+1));
         ll = ll + log(list_likelihoods{3}(test_set(idx,1)+1,test_set(idx,3)+1));
         ll = ll + log(list_likelihoods{4}(test_set(idx,3)+1,test_set(idx,4)+1));
         ll = ll + log(list_likelihoods{5}(test_set(idx,2)*2+test_set(idx,3)+1,test_set(idx,4)+1));
         ll_sum = ll_sum + ll;
    end 
end

function [list_likelihoods, filled] = calculate_em_double(train_data, list_likelihoods)

h2 = list_likelihoods{1};
b2 = list_likelihoods{2};
l2 = list_likelihoods{3};
x2 = list_likelihoods{4};
f2 = list_likelihoods{5};
h2_prev = 0;
b2_prev = 0;
l2_prev = 0;
x2_prev = 0;
f2_prev = 0;
for iter = 1:1000

filled1 = fill_missing_double(train_data, 1, [], h2, list_likelihoods);
filled2 = fill_missing_double(train_data, 2, 1, b2, list_likelihoods);
filled3 = fill_missing_double(train_data, 3, 1, l2, list_likelihoods);
filled4 = fill_missing_double(train_data, 4, 3, x2, list_likelihoods);
filled5 = fill_missing_double(train_data, 5, [2 3], f2, list_likelihoods);

filled = [filled1(:) filled2(:) filled3(:) filled4(:) filled5(:)];

h2 = calculate_wo_missing_frac(filled, 1, []);
b2 = calculate_wo_missing_frac(filled, 2, 1);
l2 = calculate_wo_missing_frac(filled, 3, 1);
x2= calculate_wo_missing_frac(filled, 4, 3);
f2 = calculate_wo_missing_frac(filled, 5, [2 3]);

delta = sum(norm(h2 - h2_prev)) + sum(norm(b2-b2_prev))+sum(norm(l2-l2_prev))+sum(norm(x2-x2_prev))+sum(norm(f2-f2_prev));

if (delta < 0.000001)
    break;
end 

h2_prev = h2;
b2_prev = b2;
l2_prev = l2;
x2_prev = x2;
f2_prev = f2;


end

list_likelihoods{1} = h2;
list_likelihoods{2} = b2;
list_likelihoods{3} = l2;
list_likelihoods{4} = x2;
list_likelihoods{5} = f2;

end


function [list_likelihoods, filled] = calculate_em(train_data, list_likelihoods)

h2 = list_likelihoods{1};
b2 = list_likelihoods{2};
l2 = list_likelihoods{3};
x2 = list_likelihoods{4};
f2 = list_likelihoods{5};

for iter = 1:10

filled1 = fill_missing(train_data, 1, [], h2);
filled2 = fill_missing(train_data, 2, 1, b2);
filled3 = fill_missing(train_data, 3, 1, l2);
filled4 = fill_missing(train_data, 4, 3, x2);
filled5 = fill_missing(train_data, 5, [2 3], f2);

filled = [filled1(:) filled2(:) filled3(:) filled4(:) filled5(:)];

h2 = calculate_wo_missing_frac(filled, 1, []);
b2 = calculate_wo_missing_frac(filled, 2, 1);
l2 = calculate_wo_missing_frac(filled, 3, 1);
x2= calculate_wo_missing_frac(filled, 4, 3);
f2 = calculate_wo_missing_frac(filled, 5, [2 3]);

end

list_likelihoods{1} = h2;
list_likelihoods{2} = b2;
list_likelihoods{3} = l2;
list_likelihoods{4} = x2;
list_likelihoods{5} = f2;

end

function params=calculate_wo_missing(data, cidx, didxes)
if numel(didxes) == 2
        for ix = 1:2*numel(didxes)
            set1 = find(data(:,didxes(1)) == bitget(ix-1,1));
            set2 = find(data(:,didxes(2)) == bitget(ix-1,2));
            setf = intersect(set1,set2);
            for jx = 1:2
                marked = find(data(setf,cidx) == (jx-1));
                params(ix,jx) = numel(marked)/numel(setf);
            end
        end
elseif numel(didxes) == 1
    didx = didxes;
    for ix = 1:2
        idx = find(data(:,didx) == (ix-1));
        data_subset = data(idx,:);
        for jx = 1:2        
            params(ix,jx) = numel(find(data_subset(:,cidx) == (jx-1)))/numel(idx);
        end
    end
elseif isempty(didxes)
    for ix = 1:2
        idx = find(data(:,cidx) == (ix-1));
        data_subset = data(idx,:);
        params(ix) = size(data_subset,1)/size(data,1);
    end
end

end


function params=calculate_wo_missing_frac(data, cidx, didxes)
if numel(didxes) == 2
        for ix = 1:2*numel(didxes)
            set1 = find(data(:,didxes(1)) == bitget(ix-1,1));
            set2 = find(data(:,didxes(2)) == bitget(ix-1,2));
            setf = intersect(set1,set2);
            data_subset = data(setf,:);
            params(ix,2) = sum(data_subset(:,cidx))/numel(setf);
            params(ix,1) = 1 - params(ix,2);
        end
elseif numel(didxes) == 1
    didx = didxes;
    for ix = 1:2
        idx = find(data(:,didx) == (ix-1));
        data_subset = data(idx,:);        
        params(ix,2) = sum(data_subset(:,cidx))/numel(idx);        
        params(ix,1) = 1 - params(ix,2);        
    end
elseif isempty(didxes)
        params(2) = sum(data(:,cidx))/size(data,1);
        params(1) = 1 - params(2);
end

end


function filled = fill_missing(data, cidx, didx,  prob)
filled = double(data(:,cidx));
idx = find(data(:,cidx) == -1);
if numel(didx) == 2
    for ix = idx(:)'
        jdx  = data(ix,didx(1));
        kdx  = data(ix,didx(2));
        row = jdx*2 + kdx + 1;
        filled(ix) = prob(row,2) ;
    end
elseif numel(didx) == 1
    for ix = idx(:)'
        row = data(ix,didx(1)) + 1;
        filled(ix) = prob(row,2) ;
    end
elseif isempty(didx)
    for ix = idx(:)'
        filled(ix) = prob(2);
    end
end
end


function filled = fill_missing_double(data, cidx, didx,  prob, list_likelihoods)
filled = double(data(:,cidx));
idx = find(data(:,cidx) == -1);
if numel(didx) == 2
    for ix = idx(:)'
        jdx  = data(ix,didx(1));
        kdx  = data(ix,didx(2));
        row = jdx*2 + kdx + 1;
        prob_prim =  list_likelihoods{1};
        if jdx == -1 || kdx == -1
            if jdx == -1
                prob_unknown = list_likelihoods{didx(1)};
                row1 = kdx+1;
                row2 = kdx+3;
            else
                prob_unknown = list_likelihoods{didx(2)};
                row1 = (2*jdx+1);
                row2 = (2*jdx+2);
            end 
            %P(F=1|B=0) 
            % = P(F=1|B=0,L=0)*{P(L=0|H=0)*P(H=0) + P(L=0|H=1)*P(H=1)} 
            % + P(F=1|B=0,L=1)*{P(L=1|H=0)*P(H=0) + P(L=1|H=1)*P(H=1)} 
            filled(ix) = ...
              prob(row1,2)* (prob_unknown(1,1)*prob_prim(1) + prob_unknown(1,2)*prob_prim(2))...
            + prob(row2,2)* (prob_unknown(2,1)*prob_prim(1) + prob_unknown(2,2)*prob_prim(2));
            
        else
            filled(ix) = prob(row,2) ;
        end 
    end
elseif numel(didx) == 1
    for ix = idx(:)'
        row = data(ix,didx(1)) + 1;
        if(row == 0)
            % P(B=1) = P(B=1|H=0)*P(H=0) + P(B=1|H=1)P(H=1)
            prob_depend = list_likelihoods{didx(1)};
            prob_depend_sum = sum(prob_depend,1);
            filled(ix) = prob(1,2)*prob_depend_sum(1) + prob(2,2)*prob_depend_sum(2);
        else
            filled(ix) = prob(row,2) ;
        end 
    end
elseif isempty(didx)
    for ix = idx(:)'
        filled(ix) = prob(2);
    end
end
end


function params=calculate_with_missing(data, cidx, didxes)
if numel(didxes) == 2
        for ix = 1:2*numel(didxes)
            set1 = find(data(:,didxes(1)) == bitget(ix-1,1));
            set2 = find(data(:,didxes(2)) == bitget(ix-1,2));
            setf = intersect(set1,set2);
            datasubset = data(setf,:);            
            for jx = 1:2
                idx = find(datasubset(:,cidx) == (jx-1));
                tidx = find(datasubset(:,cidx) ~= -1);
                params(ix,jx) = numel(idx)/numel(tidx);
            end
        end
elseif numel(didxes) == 1
    didx = didxes;
    for ix = 1:2
            idx = find(data(:,didx) == (ix-1));
            data_subset = data(idx,:);
        for jx = 1:2
            params(ix,jx) = numel(find(data_subset(:,cidx) == (jx-1)))/numel(find(data_subset(:,cidx) ~= -1));
        end
    end
elseif isempty(didxes)
    for ix = 1:2
        idx = find(data(:,cidx) == (ix-1));
        tidx = find(data(:,cidx) ~= -1);
        data_subset = data(idx,:);
        data_useful = data(tidx,:);
        params(ix) = size(data_subset,1)/size(data_useful,1);
    end
end

end

function [traindataraw] = em_read_data(filename)
fid = fopen(filename);

str = fgets(fid);
idx = 1;
while 1
    str = fgets(fid);
    if str == -1
        break;
    end
    str = strrep(str,'?','-1');
    dat = textscan(str,'%d');
    
    traindataraw(idx,:)  = dat{1}';
    idx = idx + 1;
    
end
end
