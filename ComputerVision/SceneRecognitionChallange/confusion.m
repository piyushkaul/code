x=load('/scratch/piyushk/result200_linear_dsift_fishersum_pool_7.mat');
pred =	x.predicted_label2(:);
actual = x.test_label(:);
edges = [0:15] + ones(1,16)*0.5;
confusion_mtx = zeros(15,15);
for label=1:15
	idxes = find(actual==label);
	predicted=pred(idxes);
	[nx] = histcounts(predicted,edges);
	confusion_mtx(label,:) = nx;
end



imagesc(confusion_mtx); 
%colormap(flipud(gray));
textStrings = num2str(confusion_mtx(:),'%d');  %# Create strings from the matrix values
textStrings = strtrim(cellstr(textStrings));
[x,y] = meshgrid(1:15)
hStrings = text(x(:),y(:),textStrings(:),...      %# Plot the strings
                'HorizontalAlignment','center');
%             
%             midValue = mean(get(gca,'CLim'));  %# Get the middle value of the color range
% textColors = repmat(confusion_mtx(:) > midValue,1,3);  %# Choose white or black for the
%                                              %#   text color of the strings so
%                                              %#   they can be easily seen over
%                                              %#   the background color
% set(hStrings,{'Color'},num2cell(textColors,2));  %# Change the text colors
% 
% set(gca,'XTick',1:5,...                         %# Change the axes tick marks
%         'XTickLabel',{'A','B','C','D','E'},...  %#   and tick labels
%         'YTick',1:5,...
%         'YTickLabel',{'A','B','C','D','E'},...
%         'TickLength',[0 0]);
%             