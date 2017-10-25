function [frameSamp] = processUnvoiced(coeff,pwr,FRAME_SIZE, NUM_COEFFS)

excitation = randn(1,FRAME_SIZE);
linpwr = realpow(10,pwr/10);

pwrExi = sqrt(sum(excitation.^2))/length(excitation);

pwrScale = linpwr/pwrExi;

excitation = pwrScale * excitation;
frameSamp = filter(1,coeff,excitation);

pwrFrameSamp = sqrt(sum(frameSamp.^2))/length(frameSamp);
pwrScale = linpwr/pwrFrameSamp;
frameSamp = frameSamp * pwrScale;
