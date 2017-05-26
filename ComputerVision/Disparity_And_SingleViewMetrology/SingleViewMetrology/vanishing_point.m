clear all;
close all;
global imbw;
im = imread('pic4.jpg');
imbw = rgb2gray(im);
BW = edge(imbw,'canny',[0.2 0.3]);
figure;imshow(BW);
[H,T,R] = hough(BW);
figure;imshow(H,[],'XData',T,'YData',R,'InitialMagnification','fit');
xlabel('\theta'), ylabel('\rho');
axis on, axis normal, hold on;
ceil(size(H)/50)
P  = houghpeaks(H,30,'threshold',ceil(0.2*max(H(:))));%,'NHoodSize',[101 101]);
x = T(P(:,2));
y = R(P(:,1));
plot(x,y,'s','color','white');

% Find lines and plot them
lines = houghlines(BW,T,R,P,'FillGap',200,'MinLength',1);
figure(100); imshow(imbw); hold on;
max_len = 0;

for k = 1:length(lines)
    xy = [lines(k).point1; lines(k).point2];
  
    Hand(k) = plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');
    
    % plot beginnings and ends of lines
    %figure(10);
    %plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
    %plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');
    
    % determine the endpoints of the longest line segment
    len = norm(lines(k).point1 - lines(k).point2);
    if ( len > max_len)
        max_len = len;
        xy_long = xy;
    end
end
set(Hand, 'ButtonDownFcn', {@LineSelected, Hand})

% highlight the longest line segment
plot(xy_long(:,1),xy_long(:,2),'LineWidth',2,'Color','cyan');
h = msgbox('Select Three Lines for Left Vanishing Point');
