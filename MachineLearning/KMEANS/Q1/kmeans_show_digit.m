function kmeans_show_digit(digit_no)
filename = 'digitdata.txt';
data = kmeans_read_data(filename);
digit_vals = data(digit_no,:);
final_digit = zeros(1,784);
final_digit(1:5:end) = digit_vals(1:end-1);
final_digit(end) = digit_vals(end);
final_digit2d = reshape(final_digit,28,28);
figure;imshow(final_digit2d', 'InitialMagnification', 'fit', 'DisplayRange', [0 255]);
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