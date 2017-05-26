%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Decision Tree
% (c) Piyush Kaul. 2015EEY7544
% Ans 1. Assignment 3
% Apr 2016
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [list] = create_lists(tree)

fprintf('parent_id = %d, ', tree.parent)
fprintf('nodid = %d, attribute = %d children = %d\n', tree.nodeid, tree.attribute, numel(tree.children));
if numel(tree.children) > 0
    for ix=1:numel(tree.children)
         [list_children] = create_list(tree.children{ix});
         list{} = [list list_children];
    end 
else
    fprintf('no children\n');
end 