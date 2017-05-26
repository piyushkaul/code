function [xi,yi]=find_intersection(x1,y1,x2,y2)
num_points = numel(x1);
for ln=1:num_points
slope(ln) = (y1(ln)-y2(ln))/(x1(ln)-x2(ln));
intercept(ln) = y1(ln) - slope(ln)*x1(ln);
end

n = num_points;
[p, q] = meshgrid(1:n, 1:n);
mask   = triu(ones(n), 1) > 0.5;
pairs  = [p(mask) q(mask)];

for pno=1:size(pairs,1)
    pno=pno;
    intercept(pairs(pno,1))
    intercept(pairs(pno,2))
    slope(pairs(pno,1))
    slope(pairs(pno,2))
    xin(pno) = -(intercept(pairs(pno,1))-intercept(pairs(pno,2)))/(slope(pairs(pno,1))-slope(pairs(pno,2)));
    yin(pno) = slope(pairs(pno,1)) * xin(pno) + intercept(pairs(pno,1));
end 
yin(isnan(yin)) = [];
xin(isnan(xin)) = [];
xi = mean(xin);
yi = mean(yin);
fprintf('xi=%f, yi=%f\n',xi,yi);
