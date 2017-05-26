%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Decision Tree
% (c) Piyush Kaul. 2015EEY7544
% Ans 1. Assignment 3
% Apr 2016
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function nodeout = titanic_find_node_and_prune(nodein, lidx)

nodeout = nodein;
if lidx == nodein.nodeid
    nodeout.isleaf = true;
    fprintf('tree pruned at node = %d, at depth %d, depth_idx = %d\n', nodeout.nodeid, nodeout.depth, nodeout.depth_ids);
    return;
else
    for ix = 1: numel(nodein.children);
         nodeout.children{ix} = titanic_find_node_and_prune(nodein.children{ix}, lidx);
    end 
end
