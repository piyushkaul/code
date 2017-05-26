dx=dir('/scratch/piyushk/result*7.mat');
% result800_rbf_phow_fishersum_pool_7.mat;
features = 0;
kerenel = '';
desc = '';
enc = '';
pool ='';

for ix=1:numel(dx)                      

nx = dx(ix).name;


if strfind(nx,'fisher')
enc = 'FISHER';
else
enc = 'VLAD';
end

if strfind(nx,'dsift')
desc = 'DSIFT';
else
desc = 'PHOW';
end

if strfind(nx,'rbf');
kernel = 'RBF';
else
kernel = 'LINEAR';
end

if strfind(nx,'800')
features = '800';
elseif strfind(nx,'400');
features = '400';
elseif strfind(nx,'200');
features = '200';
else
features = '1000';
end

if strfind(nx,'sum_pool');
pool = 'yes';
else
pool = 'no';
end

x=load(['/scratch/piyushk/' dx(ix).name]);
% 5 & RBF & DSIFT & FISHER  & 200  & No & 94.8207\\ \hline
fprintf('%d & %s & %s & %s & %s & %s & %f\\\\ \\hline\n',ix, kernel, desc, enc, features, pool, x.accuracy(1) );
end
