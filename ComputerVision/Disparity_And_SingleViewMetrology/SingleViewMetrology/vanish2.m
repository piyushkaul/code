Img =imread('pic2.jpg'); %read the 2D image
%Convert the image to Grayscale
I=rgb2gray(Img);

%Edge Detection
Ie=edge(I,'sobel');

%Hough Transform
[H,theta,rho] = hough(Ie);

% Finding the Hough peaks (number of peaks is set to 5)
P = houghpeaks(H,5,'threshold',ceil(0.2*max(H(:))));
x = theta(P(:,2));
y = rho(P(:,1));

%Vanishing lines
lines = houghlines(I,theta,rho,P,'FillGap',170,'MinLength',350);
[rows, columns] = size(Ie);
figure, imshow(~Ie)
hold on
xy_1 = zeros([2,2]);
for k = 1:length(lines)
   xy = [lines(k).point1; lines(k).point2];
   % Get the equation of the line
   x1 = xy(1,1);
   y1 = xy(1,2);
   x2 = xy(2,1);
   y2 = xy(2,2);
   slope = (y2-y1)/(x2-x1);
   xLeft = 1; % x is on the left edge
   yLeft = slope * (xLeft - x1) + y1;
   xRight = columns; % x is on the reight edge.
   yRight = slope * (xRight - x1) + y1;
   plot([xLeft, xRight], [yLeft, yRight], 'LineWidth',1,'Color','blue');

   %intersection of two lines (the current line and the previous one)
   slopee = @(line) (line(2,2) - line(1,2))/(line(2,1) - line(1,1));
   m1 = slopee(xy_1);
   m2 = slopee(xy);
   intercept = @(line,m) line(1,2) - m*line(1,1);
   b1 = intercept(xy_1,m1);
   b2 = intercept(xy,m2);
   xintersect = (b2-b1)/(m1-m2);
   yintersect = m1*xintersect + b1;
   plot(xintersect,yintersect,'m*','markersize',8, 'Color', 'red')
   xy_1 = xy;

   % Plot original points on the lines .
   plot(xy(1,1),xy(1,2),'x','markersize',8,'Color','yellow'); 
   plot(xy(2,1),xy(2,2),'x','markersize',8,'Color','green');    
end