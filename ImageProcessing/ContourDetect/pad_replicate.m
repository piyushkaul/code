%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% EEL715 Image Processing : Assignment 2
% Piyush Kaul  : 2015EEZ7544
%
% Description: This File has  code for Pad replication
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function img_out = pad_replicate(img)
img_out = img;
img_gray = rgb2gray(img_out);
[xsize,ysize] = size(img_gray);

for iy = 1:ysize
        [idx,idy] = find(img_gray(:,iy) ~=0);
        if ~isempty(idx)
            min_idx = min(idx);
            img_out(1:min_idx,iy,1) = img(min_idx,iy,1);
            img_out(1:min_idx,iy,2) = img(min_idx,iy,2);
            img_out(1:min_idx,iy,3) = img(min_idx,iy,3);
            max_idx = max(idx);
            img_out(max_idx:end,iy,1) = img(max_idx,iy,1);               
            img_out(max_idx:end,iy,2) = img(max_idx,iy,2);               
            img_out(max_idx:end,iy,3) = img(max_idx,iy,3);               
        end 
end 
for ix = 1:xsize    
        [idx,idy] = find(img_gray(ix,:) ~=0);
        if ~isempty(idx)
            min_idy = min(idy);
            img_out(ix,1:min_idy,1) = img(ix,min_idy,1);
            img_out(ix,1:min_idy,2) = img(ix,min_idy,2);
            img_out(ix,1:min_idy,3) = img(ix,min_idy,3);
            max_idy = max(idy);
            img_out(ix,max_idy:end,1) = img(ix,max_idx,1);        
            img_out(ix,max_idy:end,2) = img(ix,max_idx,2);        
            img_out(ix,max_idy:end,3) = img(ix,max_idx,3);        
        end 
end 

end 
