function [larCoeff] = quantizeLPC(rcCoeff)

%larCoeff=rc2lar(rcCoeff);
%larCoeff=(rcCoeff);
larCoeff = rcCoeff;
% for i = 1:length(larCoeff)
%     if(larCoeff(i) > 128)
%         larCoeff(i) = 128;
%     elseif(larCoeff(i) < 128)
%         larCoeff(i) = -128;
%     end
% end