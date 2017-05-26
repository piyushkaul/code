%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Decision Tree
% (c) Piyush Kaul. 2015EEY7544
% Ans 1. Assignment 3
% Apr 2016
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function print_specific_node_details(tree, nodeid)

if(nodeid == tree.nodeid)
    fprintf('parent_id = %d, ', tree.parent)
    fprintf('nodid = %d, attribute = %d children = %d\n', tree.nodeid, tree.attribute, numel(tree.children));

    fprintf('Node%d_%d -> Node%d_%d\n', tree.parent, tree.parent_attribute, tree.nodeid, tree.attribute)
    fprintf('Node%d: ', tree.nodeid);
    fprintf('Node Use History\n');
    fprintf('%d\t', tree.attribute_use_history);
    fprintf('\n Attribute Threshold History\n');
    for attrib=1:size(tree.attribute_threshold_history,2)
        fprintf('%d\t', tree.attribute_threshold_history(attrib,:));
        fprintf('\n');
    end
    fprintf('\n');
    return;
end

if numel(tree.children) > 0
    for ix=1:numel(tree.children)
         print_specific_node_details(tree.children{ix}, nodeid);
         
    end 
else
  %  fprintf('no children\n');
end 