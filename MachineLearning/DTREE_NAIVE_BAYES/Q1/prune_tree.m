%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Decision Tree
% (c) Piyush Kaul. 2015EEY7544
% Ans 1. Assignment 3
% Apr 2016
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [rulelists] = prune_tree(nodeout,rulelists, list_no)

global rule_no;
global list_no_global;
%global rulelists;
if list_no == 1
    rule_no = zeros(1,300);
    list_no_global = 1;
    rulelists = {};
end

list_no_orig = list_no;

rule_no(list_no) = rule_no(list_no) + 1;
rulelists{list_no}{rule_no(list_no)} = nodeout;

if nodeout.isleaf
      return;
else  
    for ix = 1: numel(nodeout.children);
          %if (ix ~= 1)
              list_no_global = list_no_global + 1; 
          %end 
          fprintf('list_no_global = %d, list_no_orig = %d, ix = %d\n', list_no_global, list_no_orig, ix);
          for jx=1:rule_no(list_no_orig)
              rulelists{list_no_global}{jx} = rulelists{list_no_orig}{jx};
              
          end 
          rule_no(list_no_global) = rule_no(list_no_orig);
          rulelists = prune_tree(nodeout.children{ix},rulelists,list_no_global);
    end 
end



end