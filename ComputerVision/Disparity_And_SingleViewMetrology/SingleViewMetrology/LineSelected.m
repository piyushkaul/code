function LineSelected(ObjectH, EventData, H)
global imbw;
set(ObjectH, 'LineWidth', 2.5,'Color','r');
global pointIdx;
global xypoint;
global vanishingPtIdx;
global vanishingPt;
if ~exist('pointIdx','var') 
    pointIdx = 1;
    vanishingPtIdx = 1;
    xypoint = [];
    vanishingPt = [];    
    figure(200);
    imshow(imbw)    
else    
    if isempty(pointIdx) 
        pointIdx = 1;
        xypoint = [];        
        figure(200);
        imshow(imbw)          
    else
        pointIdx = pointIdx + 1;
        
    end 
    if isempty(vanishingPt)
        vanishingPtIdx = 1;        
    end 
end 

xypoint(pointIdx,1) = ObjectH.XData(1);
xypoint(pointIdx,2) = ObjectH.YData(1);
xypoint(pointIdx,3) = ObjectH.XData(2);
xypoint(pointIdx,4) = ObjectH.YData(2);
fprintf('LINE=%d : X1=%f Y1 = %f, X2 = %f, Y2 = %f\n',pointIdx, xypoint(pointIdx,1), xypoint(pointIdx,2), xypoint(pointIdx,3), xypoint(pointIdx,4));
if (pointIdx >= 3)
    [xi,yi]=find_intersection(xypoint(:,1), xypoint(:,2), xypoint(:,3), xypoint(:,4));
    figure(200);
    [xymax]=axis;
    newaxis(1)=min(xi,xymax(1));
    newaxis(2)=max(xi,xymax(2));
    newaxis(3)=min(yi,xymax(3));
    newaxis(4)=max(yi,xymax(4));
    axis(newaxis);
    hold on;
    if vanishingPtIdx == 1;
        formatstr = 'rp';
    elseif vanishingPtIdx == 2;
        formatstr = 'rp';
    elseif vanishingPtIdx == 3;
        formatstr = 'rp';
    end
    
    plot(xi,yi,formatstr, 'MarkerEdgeColor','k', 'MarkerFaceColor','r',...
                       'MarkerSize',10);
    vanishingPt(vanishingPtIdx,:) = [xi yi];

    if (vanishingPtIdx < 3)
        fprintf('Vanishing Points = %f\n', vanishingPt);        
    elseif (vanishingPtIdx == 3)
        fprintf('All Vanishing Points = %f\n', vanishingPt);        
        calcCameraPosition(vanishingPt);
        fprintf('Rest Restart');  
        h = msgbox('Select Three Lines for Vanishing Point');
        
        vanishingPtIdx  = 0;
        vanishingPt = [];
        h = msgbox('Select Three Lines for  Vanishing Point');
    elseif (vanishingPtIdx > 3)
        error('Invalid Vanishing Point Idx = %d\n', vanishingPtIdx);
    end 
    if vanishingPtIdx == 2
        figure(200);
        hold on;
        plot(vanishingPt(:,1),vanishingPt(:,2),'r--','LineWidth',2)
    end 
    vanishingPtIdx = vanishingPtIdx + 1;
    clear xypoint;
    pointIdx = [];
end 

%set(H(H ~= ObjectH), 'LineWidth', 0.5);