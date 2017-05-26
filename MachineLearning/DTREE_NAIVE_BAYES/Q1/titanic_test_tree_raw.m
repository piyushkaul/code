%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Decision Tree
% (c) Piyush Kaul. 2015EEY7544
% Ans 1. Assignment 3
% Apr 2016
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [detection_precentage] = titanic_test_tree(tree, test_data, max_node_depth,max_depth_id, verbose)
testcases = size(test_data,1);
errors = 0;
correct_detections = 0;
for tc = 1:testcases
    next_node = tree;
    while 1
        if next_node.isleaf || next_node.nodeid > max_depth_id 
               %(next_node.depth > max_node_depth) || ...
               % ((next_node.depth == max_node_depth) &&(next_node.depth_ids >= max_depth_id))
               
            survive = next_node.survive;
            if(survive == test_data(tc,1))
                if verbose fprintf('TC=%d, correct decision\n', tc); end
                correct_detections = correct_detections + 1;
            else
                if verbose fprintf('TC=%d, wrong decision\n',  tc); end
                errors  = errors + 1;
            end 
            break;
        end 
        branch_to_take = test_data(tc,next_node.attribute);
        if (branch_to_take+1) > numel(next_node.children)
            if 0
                if verbose fprintf('TC=%d, wrong decision. unseen combo\n', tc); end
                errors  = errors + 1;
            else
                survive = next_node.survive;
                if(survive == test_data(tc,1))
                    if verbose fprintf('TC=%d, correct decision\n', tc); end
                    correct_detections = correct_detections + 1;
                else
                    if verbose fprintf('TC=%d, wrong decision\n',  tc); end
                    errors  = errors + 1;
                end 
            end
            %
            break;
        end 
        next_node = next_node.children{branch_to_take+1};
    end 
end 
detection_precentage = correct_detections/testcases*100;
fprintf('\n###########################################################################\n');
fprintf('Errors = %d, Total Test Cases = %d , Detection Percentage = %f%%', errors, testcases, detection_precentage);
fprintf('\n###########################################################################\n');