%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% EEL715 Image Processing : Assignment 2
% Piyush Kaul  : 2015EEZ7544
% Description: This File has  code for Hough Transform
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function xy = hough_poly(BW)
% I  = imread('circuit.tif');
    %   rotI = imrotate(I,33,'crop');
    %   BW = edge(rotI,'canny');
       [H,T,R] = hough(BW);
   %    imshow(H,[],'XData',T,'YData',R,'InitialMagnification','fit');
   %    xlabel('\theta'), ylabel('\rho');
   %    axis on, axis normal, hold on;
       P  = houghpeaks(H,5,'threshold',ceil(0.3*max(H(:))));
       x = T(P(:,2)); 
       y = R(P(:,1));
       plot(x,y,'s','color','white');
 
       % Find lines and plot them
       lines = houghlines(BW,T,R,P,'FillGap',5,'MinLength',7);
      
       for k = 1:length(lines)
         xy = [lines(k).point1; lines(k).point2];
       end
 
      
