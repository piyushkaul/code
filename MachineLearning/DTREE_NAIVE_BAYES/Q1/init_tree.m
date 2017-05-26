%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Decision Tree
% (c) Piyush Kaul. 2015EEY7544
% Ans 1. Assignment 3
% Apr 2016
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function tree = init_tree()
numAttrib = 11;
maxDepth = 10;
global max_node_id;
global depth_ids; 
max_node_id = 0;
depth_ids = zeros(1,100);
    tree = struct('children', [], 'parent', 0, 'nodeid', 0, 'attribute', 0, 'attribute_use_history', zeros(1,numAttrib), 'attribute_threshold_history',zeros(numAttrib,maxDepth));
return ;