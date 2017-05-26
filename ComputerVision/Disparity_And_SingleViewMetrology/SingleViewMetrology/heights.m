function rat = heights(vp1,vp2,vp3)

im = imread('pic2.jpg');
figure;imshow(im);

fprintf('select Person Top\n');
[x1,y1] = ginput(1);
fprintf('Point Selectd = %f, %f\n',x1,y1);

fprintf('select Building Top\n');
[x2,y2] = ginput(1);
fprintf('Point Selectd = %f, %f\n',x2,y2);

fprintf('select Ground\n');
[x3,y3] = ginput(1);
fprintf('Point Selectd = %f, %f\n',x3,y3);

numer1 = ((x1-x3)^2 + (y1-y3)^2)^0.5;
denom1 = ((x2-x3)^2 + (y2-y3)^2)^0.5;

rat1 = numer1/denom1;

numer2 = ((x1-vp3(1))^2 + (y1-vp3(2))^2)^0.5;
denom2 = ((x2-vp3(1))^2 + (y2-vp3(2))^2)^0.5;

rat2 = numer2/denom2;

rat = rat1/rat2;
fprintf('The ratio is %f\n',rat);