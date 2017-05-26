%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Decision Tree
% (c) Piyush Kaul. 2015EEY7544
% Ans 1. Assignment 3
% Apr 2016
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [traindata, medStruct] = titanic_read_processes_data(filename, mode, medStruct)
fid = fopen(filename);
%1,1,female,35.0,1,0,36973.0,83.475,S,C,83.0
str = fgets(fid);
itr = 1;
%traindataraw = cell(m,11);
%traindata = zeros(m,11);
while 1
str = fgets(fid);
if str == -1
    break;
end
temp = textscan(str,'%d%d%s%f%d%d%f%f%c%c%f','Delimiter',',');
traindataraw(itr,:)  = temp;
itr = itr+ 1;
end
m = itr - 1;
if strcmp(mode,'train')
    medStruct.medianage = median(cell2mat(traindataraw(:,4)));
    medStruct.mediansibsp = median(cell2mat(traindataraw(:,5)));
    medStruct.medianparch = median(cell2mat(traindataraw(:,6)));
    medStruct.medianticket = median(cell2mat(traindataraw(:,7)));
    medStruct.medianfare = median(cell2mat(traindataraw(:,8)));
    medStruct.mediancabb = median(cell2mat(traindataraw(:,11)));
end


for idx =1:m
    traindata(idx,1) = cell2mat(traindataraw(idx,1));
    traindata(idx,2) = cell2mat(traindataraw(idx,2))-1;
    
    mf  = traindataraw{idx,3};
    
    if strcmp(mf,'female')
        traindata(idx,3) = 0;
    else
        traindata(idx,3) = 1;
    end 
    
    
    traindata(idx,4) = cell2mat(traindataraw(idx,4)) > medStruct.medianage;
    traindata(idx,5) = cell2mat(traindataraw(idx,5)) > medStruct.mediansibsp;
    traindata(idx,6) = cell2mat(traindataraw(idx,6)) > medStruct.medianparch;
    traindata(idx,7) = cell2mat(traindataraw(idx,7)) > medStruct.medianticket;
    traindata(idx,8) = cell2mat(traindataraw(idx,8)) > medStruct.medianfare;
    
    embark  = cell2mat(traindataraw(idx,9));
    
    if embark=='S'
        traindata(idx,9) = 0;
    elseif embark == 'C'
        traindata(idx,9) = 1;
    elseif embark == 'Q'
        traindata(idx,9) = 2;
    end
    
    cabin = cell2mat(traindataraw(idx,10));
    if cabin == '0'       
        traindata(idx,10) = 0;
    elseif cabin == 'A'
        traindata(idx,10) = 1;
    elseif cabin == 'B'        
        traindata(idx,10) = 2;
    elseif cabin == 'C'        
        traindata(idx,10) = 3;
    elseif cabin == 'D'        
        traindata(idx,10) = 4;
    elseif cabin == 'E'        
        traindata(idx,10) = 5;
    elseif cabin == 'G'        
        traindata(idx,10) = 6;                
    end 
    traindata(idx,11) = cell2mat(traindataraw(idx,11)) > medStruct.mediancabb;
    
end