clear all;
run('vlfeat-0.9.20/toolbox/vl_setup');
addpath('libsvm-3.21/matlab');
dir_prefix='/scratch/piyushk/'

%Number of Feature dimension
K_all = [200,400,800,1000];
%Types of kernels Dimensions Tried
kernel_used_all = {'linear','rbf'};
kernel_used_all = {'linear'};
%Types of feature descriptors tried
feature_used_all = {'dsift','phow'};
% Types of Encoding Tried
encoder_used_all = {'fisher', 'vlad'};
% types of Pooling Algorithm Tried
pool_used_all = {'sum_pool','none'};
encoder_used_all = {'fisher'};


% Final Combination used for this simul
 kernel_used_all = {'rbf'};
 feature_used_all = {'dsift'};
 encoder_used_all = {'fisher'};
 pool_used_all = {'sum_pool'};
% K_all = [200];

%Version number appended to all files.
ver_code = '_7';

% For all types of Pooling
for pool_idx = 1:numel(pool_used_all)
% For all Types of Encoding
for encoder_idx = 1:numel(encoder_used_all)
% For all sizes of feature Dimensions
for K_idx = 1:numel(K_all)
% For all SVM kernel indices
    for kernel_idx =1:numel(kernel_used_all)
% For all types of feature types
        for feature_idx =1:numel(feature_used_all)
	    %% Clear All variables except configuration
            clearvars -except *_idx *_all dir_prefix ver_code
            
	    %% Set the current loop configuration
            feature_used = feature_used_all{feature_idx};
            kernel_used = kernel_used_all{kernel_idx};
	    encoder_used = encoder_used_all{encoder_idx};
	    pool_used = pool_used_all{pool_idx};
            K = K_all(K_idx);
            
	    %version string to be used for files
            code_ver = [num2str(K) '_' kernel_used '_' feature_used '_' encoder_used pool_used ver_code];        
            
	    %final file names for intermediate files
            imrs_file = [dir_prefix 'imrs' '.mat'];
            global_file = [dir_prefix 'globalstat' feature_used encoder_used ver_code '.mat'];
            descriptor_file = [dir_prefix 'descriptor' code_ver '.mat'];
            model_file = [dir_prefix 'model' code_ver '.mat'];
            result_file = [dir_prefix 'result' code_ver '.mat'];
            
            
	    % check if image database exists
            if ~exist(imrs_file,'file');
                dirs=dir('dataset');
                label_no = 1;
                jx = 1;
		% For each directory/label read all the filenames
                for ix=3:numel(dirs)
                    dx=dirs(ix);
                    dirs2 = dir(fullfile('dataset',dx.name));
                    for kx=3:numel(dirs2)
                        imrs.pathx{jx} = fullfile('dataset',dx.name,dirs2(kx).name);
                        imrs.label(jx) = label_no;
                        jx = jx + 1;
                    end
                    label_no = label_no + 1;
                end
                label_no = label_no - 1;
                num_pics = numel(imrs.label);
                imrs.data = zeros(64,64,num_pics);
		% For all the files in the directory
                for pic=1:num_pics
                    fprintf('Image %s\n',imrs.pathx{pic});
		    % Read the image file
                    im = imread(imrs.pathx{pic});
                    sz = size(im);
	            % Convert to grayscale if required
                    if numel(sz) == 3
                        im = rgb2gray(im);
                    end
		    % resize to 64x64 and store into image database
                    imrs.data(:,:,pic) = imresize(im,[64 64]);
                end
		% Store label
                imrs.label_no = label_no;
		% Store number of pictures
                imrs.num_pics = num_pics;
	        % Percentage of Training images
                imrs.train_percent = 0.5;
                % Percentage of Test Images
                imrs.test_percent = 1 - imrs.train_percent;
	        % Training Images Ramdomized
                imrs.train_id = randperm(imrs.num_pics,fix(imrs.train_percent*imrs.num_pics));
	        % Test Images
                imrs.test_id = setdiff([1:numel(imrs.label)],imrs.train_id);
		% Save image database into a file
                save(imrs_file,'imrs');
            else
		% If exists read from  matfile
                load(imrs_file);
            end

	    % If Global Statistics File  Doesn't exist
            if ~exist(global_file,'file');
		% Fraction of images to be used for Global Statistics
                fract = 0.1;
                %idxes_used = idx_in_class(idxes2);
		% Descriptors initialized to empty
                descr_all = [];
		% Total Images to be used for Global Statistics                
                images_used_num = fix(numel(imrs.train_id)*fract);
		% Indxes Randomized from training set
                idxes = randperm(numel(imrs.train_id),images_used_num);
		% Final Indexes (absolute)
                idxes_used = imrs.train_id(idxes);
		
                fprintf('\nTotal Images = %d, Images Used = %d\n',numel(imrs.train_id),images_used_num);
		% For Each of the images
                for pic_id = idxes_used
                    fprintf('.');
                    im = imrs.data(:,:,pic_id);
		    %extract the descriptors
                    if strcmp(feature_used,'dsift')
                        [frames, descri]=vl_dsift(single(im));
                    else
                        %[frames, descr]=vl_phow(single(im), 'step',1,'sizes',[4 8 12 16]);
                        [frames, descri]=vl_phow(single(im), 'step',4, 'sizes', [4 8]);
                    end
                    descr_all = [descr_all descri];
                end
                
                %Obtain the global statistics based on encoding used
		if strcmp(encoder_used,'fisher')
			% GMM model obtained for Fisher
	                [globalstat.means, globalstat.covariances, globalstat.priors] = vl_gmm(single(descr_all), K);
		else
			% Kmeans centroids obtained for VLAD
			numClusters = K ;
			globalstat.centers = vl_kmeans(single(descr_all), numClusters);
		end
		% Save Global Statistics
                save(global_file,'globalstat');
            else
		% Load Global Statistics if already exist
                load(global_file);
            end
            
            if ~exist(descriptor_file,'file')
                for pic=1:imrs.num_pics
                    
                    im = imrs.data(:,:,pic);
                    imcrop{1} = im;
                    imcrop{2} = im(1:end/2,1:end/2);
                    imcrop{3} = im(end/2+1:end,1:end/2);
                    imcrop{4} = im(1:end/2,end/2+1:end);
                    imcrop{5} = im(end/2+1:end,end/2+1:end);
%		    if 0
%		    for hidx=1:4
%		    for vidx=1:4
%		    imcrop{5+4*(hidx-1)+vidx} = im((hidx-1)/4*end+1:(hidx)/4*end,(vidx-1)/4*end+1:(vidx)/4*end);
%		    end
%	            end
%	            end
                    class_id = imrs.label(pic);

		    if strcmp(pool_used,'sum_pool')
			crops_used=1:numel(imcrop);
		    else
			crops_used=1;
		    end

		    for cropnum=crops_used;
                    tic
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    if strcmp(feature_used, 'dsift');
                        [frames, descr{cropnum}]=vl_dsift(single(imcrop{cropnum}));
                    else
                        [frames, descr{cropnum}]=vl_phow(single(imcrop{cropnum}),'step',4, 'sizes',[4 8]);%,'sizes',[4 8 12 16]);
                    end
                    if strcmp(encoder_used,'fisher')
                        encoding_crop(cropnum,:) = vl_fisher(single(descr{cropnum}), globalstat.means, globalstat.covariances, globalstat.priors);
                        encoding_crop(cropnum,:) = encoding_crop(cropnum,:)/norm(encoding_crop(cropnum,:));
                    else
			kdtree = vl_kdtreebuild(globalstat.centers) ;
			nn = vl_kdtreequery(kdtree, globalstat.centers, single(descr{cropnum})) ;
			assignments = zeros(K,size(descr{cropnum},2),'single');
			assignments(sub2ind(size(assignments), nn, 1:length(nn))) = 1;
			encoding_crop(cropnum,:) = vl_vlad(single(descr{cropnum}),globalstat.centers,assignments);
			encoding_crop(cropnum,:) = encoding_crop(cropnum,:)/norm(encoding_crop(cropnum,:));

                    end
	            end
                     encoding = max(encoding_crop);
	%	    encoding = encoding/norm(encoding);
			
%	            end
                    %         end
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    toc
                    fprintf('PIC=%d/%d\n',pic,imrs.num_pics);
                    %[C,I] = vl_ikmeans((descr),K,'method','elkan');
                    %histf(pic,:) = vl_ikmeanshist(K,I)';
                    histf(pic,:) = encoding;
                end
                descriptor.histf = histf;
                %res.descr = descr_all;
                save(descriptor_file,'descriptor');
            else
                fprintf('File Exists!!\n');
                load(descriptor_file);
            end
            
            
            
            %all_descr = [descr{:}];
            %centroids = vl_kmeans(single(all_descr),8);
            train_data = descriptor.histf(imrs.train_id,:);
            train_label = imrs.label(imrs.train_id);
            test_data = descriptor.histf(imrs.test_id,:);
            test_label = imrs.label(imrs.test_id);
            scalefactor = max(descriptor.histf);
	    size(train_data)
	    size(train_label)
	    size(test_data)
	    size(test_label)
            %train_data = train_data./repmat(scalefactor,size(train_data,1),1);
            %test_data = test_data./repmat(scalefactor,size(test_data,1),1);
            %model1 = svmtrain(train_label',train_data,'-t 2 -s 0 -c 1 -g 2.5e-4');
            if ~exist(model_file,'file')
                if strcmp(kernel_used,'rbf')
                    model1 = svmtrain(double(train_label'),double(train_data),'-t 2 -s 0 -c 1 -g 1e-1');
                else
                    model1 = svmtrain(double(train_label'),double(train_data),'-t 0 -s 0 -c 1 ');
                end
                save(model_file,'model1');
            else
                load(model_file);
            end
            %[predicted_label2] = svmpredict(test_label',test_data,model1);
            [predicted_label2, accuracy, dummy] = svmpredict(double(test_label'),double(test_data),model1);
            save(result_file,'predicted_label2','accuracy','test_label');
        end
    end
end
end
end




