%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Decision Tree
% (c) Piyush Kaul. 2015EEY7544
% Ans 1. Assignment 3
% Apr 2016
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all;
DFS = 0;

global numerical_fields;
numerical_fields = [4 5 6 7 8 11];
global depth_ids;
[traindata, medstruct] = titanic_read_processes_data_raw('dtree_data_code\train.csv', 'raw', []);
testdata = titanic_read_processes_data_raw('dtree_data_code\test.csv', 'raw', medstruct);
validationdata = titanic_read_processes_data_raw('dtree_data_code\validation.csv', 'raw', medstruct);

tree = init_tree();
tree = titanic_create_tree_raw(tree, traindata, 1, 0);
%print_tree(tree);
depth_ids = depth_ids(find(depth_ids>0));

detection_precentage_train_base = titanic_test_tree_raw(tree, traindata, Inf, Inf, 0);
detection_precentage_validation_base = titanic_test_tree_raw(tree, validationdata, Inf, Inf, 0);
detection_precentage_test_base = titanic_test_tree_raw(tree, testdata, Inf, Inf, 0);


if DFS
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
else
    depth = 0;
    num_nodes = sum(depth_ids);
    idx = 1;
    for lidx=1:num_nodes
        detection_precentage_train(idx) = titanic_test_tree_raw(tree, traindata, depth, lidx, 0);
        idx = idx + 1;
    end
    
    
    idx = 1;
    
    for lidx=1:num_nodes
        detection_precentage_validation(idx) = titanic_test_tree_raw(tree, validationdata, depth, lidx, 0);
        idx = idx + 1;
    end
    
    idx = 1;
    
    for lidx=1:num_nodes
        detection_precentage_test(idx) = titanic_test_tree_raw(tree, testdata, depth, lidx, 0);
        idx = idx + 1;
    end
end

figure;plot(detection_precentage_train,'r');
hold on;
plot(detection_precentage_validation,'g');
plot(detection_precentage_test,'b')
legend('training', 'validation', 'test');

 xlabel('number of nodes');
 ylabel('detection percentage %');
 title('detection vs number of nodes without preprocessing numerical attributes');
 print_tree(tree);
 print_specific_node_details(tree,214)
 fprintf('Detection Percentage for Train = %f, Validation = %f, Test = %f\n', detection_precentage_train_base, detection_precentage_validation_base, detection_precentage_test_base);