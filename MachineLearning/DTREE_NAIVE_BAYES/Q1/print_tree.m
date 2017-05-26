%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Decision Tree
% (c) Piyush Kaul. 2015EEY7544
% Ans 1. Assignment 3
% Apr 2016
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function print_tree(tree)

%fprintf('parent_id = %d, ', tree.parent)
%fprintf('nodid = %d, attribute = %d children = %d\n', tree.nodeid, tree.attribute, numel(tree.children));

%fprintf('Node%d_%d -> Node%d_%d\n', tree.parent, tree.parent_attribute, tree.nodeid, tree.attribute)
fprintf('Node%d: ', tree.nodeid);
fprintf('%d\t', tree.attribute_use_history);
fprintf('\n');

if numel(tree.children) > 0
    for ix=1:numel(tree.children)
         print_tree(tree.children{ix});
         
    end 
else
  %  fprintf('no children\n');
end 
    