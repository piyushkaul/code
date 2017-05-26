
function calcCameraPosition(vpin)

%vp = [-617.949234, 561.464354, 0; ...
%      2341.390951, 477.155500, 0; ...
%     269.296875, -4312.486979, 0];

if ~exist('vpin','var')
vp = [...
    -467   500    1;...
    2341   477    1;...
    269   -4312   1;...
];


vp = [1111.716826 758.538785 1;...
-953.008363 862.983066 1;...
286.297838 -777.813331 1;];


vp = [238.300642	-1813.995238 1;...
1044.517911	515.521447 1;...
-328.105876	516.614504 1;...
]


vp = [-54.364775  567.916490   1;...
    1224.9      578.331715    1;...
    1           1             0]

else
    vp = [vpin ones(3,1)];
    if isnan(vpin(3,1))
        vp(3,:) = [1 1 0];    
    end     
end




vp1 = vp(1,:)';
vp2 = vp(2,:)';
vp3 = vp(3,:)';

K= calculateCalibrationMatrix(vp);

fprintf('Calibration Matrix\n');
fprintf([repmat(' %f ', 1, 3) '\n'], K)

R1C = inv(K)*vp1;
R2C = inv(K)*vp2;
R3C = inv(K)*vp3;

R1C = R1C/norm(R1C);
R2C = R2C/norm(R2C);
R3C = R3C/norm(R3C);

R = [R1C R2C R3C];
fprintf('Reflection Matrix=\n');
fprintf([repmat(' %f ', 1, 3) '\n'], R)

projectionMtx = vp'; 


VanishingLine = cross(projectionMtx(:,1), projectionMtx(:,2));
fprintf('Vanishig Line Matrix=\n');
fprintf([repmat(' %f ', 1, 3) '\n'], R)


projectionMtx = [projectionMtx VanishingLine/norm(VanishingLine)];
p = projectionMtx;

xc = det([p(:,2) p(:,3) p(:,4)]);
yc = det([p(:,1) p(:,3) p(:,4)]);
zc = det([p(:,1) p(:,2) p(:,4)]);
wc = det([p(:,1) p(:,2) p(:,3)]);
fprintf('Projection Matrix=\n');
fprintf([repmat(' %f ', 1, 3) '\n'], R)


r=projectionMtx(1:3,1:3);
f=projectionMtx(:,4);
cameraCoord=inv(r)*f;

cameraCoord = cameraCoord*1000;
fprintf('Camera Co-ordinates (scale:1000) = %3.3f \n',cameraCoord);



ratio = heights(vp1,vp2,vp3);
ref_height = [];
while isempty(ref_height)
    ref_height = input('Give the height of the reference : ','s');
end 
ref_height_n = str2double(ref_height);
fprintf('height of the Building is = %f\n', ref_height_n / ratio);