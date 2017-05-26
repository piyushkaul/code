%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Decision Tree
% (c) Piyush Kaul. 2015EEY7544
% Ans 1. Assignment 3
% Apr 2016
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function nodeout = titanic_create_tree(nodein, traindata, idx, depth)
global max_node_id; 
global depth_ids;
%node = struct('parent',[], 'attribute', [], 'partitions', {}, 'node', [], 'isleaf', [], 'survive', []);

if numel(unique(traindata(:,1))) == 1
    partitions{1} = traindata;
    attribute_id = 0;
else 
    [attribute_id, partitions] = get_best_atribute(traindata, 'now');
end    

nodeout.attribute = attribute_id;
nodeout.partitions = partitions;
nodeout.isleaf = false;
nodeout.parent =  nodein.nodeid;
nodeout.parent_attribute =  nodein.attribute;
nodeout.attribute_use_history = nodein.attribute_use_history;
if attribute_id ~= 0
nodeout.attribute_use_history(attribute_id)  = nodeout.attribute_use_history(attribute_id)  +  1;
end
nodeout.depth = depth;
depth_ids(depth+1) = depth_ids(depth+1) +  1;
nodeout.depth_ids = depth_ids(depth+1);
max_node_id = max_node_id + 1;
nodeout.nodeid = max_node_id;

nodeout.survive = mode(traindata(:,1));

%tree.node(idx) = node;
fprintf('Adding Node Id = %d, to Node Id = %d at idx=%d\n', max_node_id, nodein.nodeid, idx);

if numel(partitions) == 1
      nodeout.isleaf = true;
      nodeout.children = {};
      return;
else
    for ix = 1: numel(partitions);
         partition=cell2mat(partitions{ix});
         %partition(:,attribute_id) = 0;
         nodeout.children{ix} = titanic_create_tree(nodeout, partition, ix, depth+1);
    end 
end
