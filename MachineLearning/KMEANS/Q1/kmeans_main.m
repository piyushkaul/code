function kmeans_main()
filename = 'digitdata.txt';
filename_label = 'digitlabels.txt';
data = kmeans_read_data(filename);
labels = kmeans_read_labels(filename_label );
[clusters, centroids] = kmeans_iterations(data,4, labels);


end
function [clusters, centroids] = kmeans_iterations(data, numclusters, labels)
centroids = kmeans_init(data, numclusters);
prevclusters = {};
for iter = 1:30
    clusters = kmeans_get_clusters_from_centroids(data,centroids, numclusters);
    centroids = kmeans_get_centroids_from_clusters(data, clusters, numclusters);
    
    err(iter) = kmeans_mse_from_centroids(data, clusters, centroids);
    
    [correct(iter), incorrect(iter)] = kmeans_find_mislabel_error(data, clusters, centroids, labels);
    correct_percentage(iter) = correct/(correct+incorrect)*100;
    fprintf('Percentage Correct = %f\n', correct_percentage);
    
    if isequal(clusters,prevclusters)
        fprintf('converged in iteration = %d!!\n', iter);
        break;
    end 
    prevclusters = clusters;
end
figure;
plot(err,'b');
xlabel('iterations');
ylabel('Mean Square Error');
title('MSE vs Iterations');
figure;
plot(correct_percentage,'r');
xlabel('iterations');
ylabel('Correct Classification Percentage');
title('Correct Classification vs Iterations');

end

function [correct, incorrect] = kmeans_find_mislabel_error(data, clusters, centroids, labels)
sz1 = size(centroids);
correct = 0;
incorrect = 0;
    for idx = 1:sz1(2)
        points = clusters{idx};
        commonest_label = mode(labels(points));
        correct = correct+ numel(find(labels(points) == commonest_label));
        incorrect = incorrect + numel(find(labels(points) ~= commonest_label));
    end

end

function err = kmeans_mse_from_centroids(data, clusters, centroids)

sz1 = size(centroids);
err = 0;
for clustidx = 1: sz1(2)
    points = clusters{clustidx};
    for pointidx = points
        err = err + norm((double(data(pointidx,:) - centroids{clustidx})));
    end
end
end


function centroids = kmeans_init(data, num_centroids)
sz = size(data);
idxes = randi(sz(1),1,num_centroids);
%idxes = [1 420 600 850];
for ix = 1: num_centroids
    centroids{ix} = data(idxes(ix),:);
    %centroids{ix} = randi([0 255], size(data(idxes(ix))));
end
end


function centroid_idx = checkdistance(point, centroids)
sz = size(centroids);
min_dist = inf;
centroid_idx = 0;
for idx = 1:sz(2)
    dist = norm(double(point - centroids{idx}));
    if dist < min_dist
        min_dist = dist;
        centroid_idx = idx;
    end
end
end

function clusters = kmeans_get_clusters_from_centroids(data, centroids, numclusters)
clusters = {};
sz = size(data);
for ix = 1:numclusters
    clusters{ix} = [];
end
for idx = 1:sz(1)
    point = data(idx,:);
    centroid_idx = checkdistance(point, centroids);
    clusters{centroid_idx} = [clusters{centroid_idx} idx];
end
end

function centroids = kmeans_get_centroids_from_clusters(data, clusters, numclusters)
sz = size(data);
%centroids = zeros(numclusters,sz(2) );
for cluster_no=1:numclusters
    data_idx = clusters{cluster_no};
    centroids{cluster_no}  = mean(data(data_idx,:));
end




end



function [traindataraw] = kmeans_read_data(filename)
fid = fopen(filename);

str = fgets(fid);
idx = 1;
while 1
    str = fgets(fid);
    if str == -1
        break;
    end
    [temp pos] = textscan(str,'"%d"');
    [dat, pos]=textscan(str(pos:end),'%d','Delimiter',' ');
    traindataraw(idx,:)  = double(dat{1}(:)');
    idx = idx + 1;
    
end
end

function [label] = kmeans_read_labels(filename)
fid = fopen(filename);
str = fgets(fid);
idx = 1;
while 1
    str = fgets(fid);
    if str == -1
        break;
    end
    [temp pos] = textscan(str,'"%d"');
    [dat, pos]=textscan(str(pos+1:end),'%d','Delimiter',' ');
    label(idx)  = dat{1};
    idx = idx + 1;
    end
end