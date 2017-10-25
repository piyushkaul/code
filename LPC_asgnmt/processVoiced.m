function [frameSamp] = processVoiced(coeff,pitch, pwr,FRAME_SIZE, NUM_COEFFS)

excitation = zeros(1,FRAME_SIZE);
for i=1:pitch:FRAME_SIZE
    excitation(i) = 1;
end

% glottalPulse = rosenburgExcitation(20,5);
% excitation = conv(glottalPulse,excitation);
% excitation = excitation(1:FRAME_SIZE);

linpwr = realpow(10,pwr/10);
pwrExi = sqrt(sum(excitation.^2))/length(excitation);
pwrScale = linpwr/pwrExi;
excitation = excitation * pwrScale;

frameSamp = filter(1,coeff,excitation);

pwrFrameSamp = sqrt(sum(frameSamp.^2))/length(frameSamp);
pwrScale = linpwr/pwrFrameSamp;
frameSamp = frameSamp * pwrScale;