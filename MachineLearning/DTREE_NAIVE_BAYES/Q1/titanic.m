%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Decision Tree
% (c) Piyush Kaul. 2015EEY7544
% Ans 1. Assignment 3
% Apr 2016
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all;
DFS = 0;
BFS = 1;
enable_prune = 1;
global depth_ids;

[traindata, medstruct] = titanic_read_processes_data('dtree_data_code\train.csv', 'train', []);
testdata = titanic_read_processes_data('dtree_data_code\test.csv', 'test', medstruct);
validationdata = titanic_read_processes_data('dtree_data_code\validation.csv', 'test', medstruct);

tree = init_tree();
tree = titanic_create_tree(tree, traindata, 1, 0);
print_tree(tree);
depth_ids = depth_ids(find(depth_ids>0));

detection_precentage_train_base = titanic_test_tree(tree, traindata, Inf, Inf, 0);
detection_precentage_val_base = titanic_test_tree(tree, validationdata, Inf, Inf, 0);
detection_precentage_test_base = titanic_test_tree(tree, testdata, Inf, Inf, 0);

if DFS==1
    idx = 1;
    for depth=1:numel(depth_ids)
        for lidx=1:depth_ids(depth)
            detection_precentage_train(idx) = titanic_test_tree(tree, traindata, depth, lidx, 0);
            idx = idx + 1;
        end
    end
    
    idx = 1;
    for depth=1:numel(depth_ids)
        for lidx=1:depth_ids(depth)
            detection_precentage_validation(idx) = titanic_test_tree(tree, validationdata, depth, lidx, 0);
            idx = idx + 1;
        end
    end
    
    idx = 1;
    for depth=1:numel(depth_ids)
        for lidx=1:depth_ids(depth)
            detection_precentage_test(idx) = titanic_test_tree(tree, testdata, depth, lidx, 0);
            idx = idx + 1;
        end
    end
end 
if BFS==1
    depth = 0;
    num_nodes = sum(depth_ids);
    idx = 1;
    for lidx=1:num_nodes
        detection_precentage_train(idx) = titanic_test_tree(tree, traindata, depth, lidx, 0);
        idx = idx + 1;
    end
    
    
    idx = 1;
    
    for lidx=1:num_nodes
        detection_precentage_validation(idx) = titanic_test_tree(tree, validationdata, depth, lidx, 0);
        idx = idx + 1;
    end
    
    idx = 1;
    
    for lidx=1:num_nodes
        detection_precentage_test(idx) = titanic_test_tree(tree, testdata, depth, lidx, 0);
        idx = idx + 1;
    end
end

if enable_prune
    ids_to_be_pruned = [];
    %rulelists = prune_tree(tree, {}, 1);
    num_nodes = sum(depth_ids);
    idx = 1;
    depth = 0;
    for lidx=1:num_nodes
        tree_temp = titanic_find_node_and_prune(tree, lidx);
        detection_precentage_prune(lidx) = titanic_test_tree(tree_temp, validationdata, Inf, Inf, 0);
        if(detection_precentage_prune(lidx) > detection_precentage_val_base)
            ids_to_be_pruned = [ids_to_be_pruned lidx];
        end
            
    end
    pruned_tree = tree;
    for ids = 1:num_nodes
        if ismember(ids,ids_to_be_pruned);
            pruned_tree = titanic_find_node_and_prune(pruned_tree, ids);
        end 
        detection_precentage_prune_fin_val(ids) = titanic_test_tree(pruned_tree, validationdata, Inf, Inf, 0);
        detection_precentage_prune_fin_train(ids) = titanic_test_tree(pruned_tree, traindata, Inf, Inf, 0);
        detection_precentage_prune_fin_test(ids) = titanic_test_tree(pruned_tree, testdata, Inf, Inf, 0);
    end 
    
    
    figure;plot(detection_precentage_prune_fin_train,'r');
    hold on;
    plot(detection_precentage_prune_fin_val,'g');
    plot(detection_precentage_prune_fin_test,'b')
    legend('training', 'validation', 'test');
    xlabel('number of nodes');
    ylabel('detection percentage %');
    title('detection perecentage change  as we iterate over nodes for pruning')
    
    detection_precentage_pruned_train =  titanic_test_tree(pruned_tree, traindata, Inf, Inf, 0);
    detection_precentage_pruned_validation =  titanic_test_tree(pruned_tree, validationdata, Inf, Inf, 0);
    detection_precentage_pruned_test =  titanic_test_tree(pruned_tree, testdata, Inf, Inf, 0);
end 
    
if BFS==1 || DFS==1
    figure;plot(detection_precentage_train,'r');
    hold on;
    plot(detection_precentage_validation,'g');
    plot(detection_precentage_test,'b')
    if enable_prune    
        detection_precentage_pruned_train_vec = ones(1,180)*detection_precentage_pruned_train;
        detection_precentage_pruned_test_vec = ones(1,180)*detection_precentage_pruned_test;
        detection_precentage_pruned_validation_vec = ones(1,180)*detection_precentage_pruned_validation;
        plot(detection_precentage_pruned_train_vec, 'r:')
        plot(detection_precentage_pruned_validation_vec, 'g:')
        plot(detection_precentage_pruned_test_vec, 'b:');
        legend('training', 'validation', 'test','train after prune', 'validation after prune', 'test after prune');
    else
        legend('training', 'validation', 'test');
    end
    xlabel('number of nodes');
    ylabel('detection percentage %');
    title('detection vs number of nodes')

end
