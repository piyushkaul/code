function [outSamp] = decodeLPC(encodedCoeff, encodedPwr, encodedPitch, FRAME_SIZE, NUM_COEFFS)

numFrames = length(encodedPwr);

outSamp = [];
frameSamp = [];

prevSamp = zeros(1,FRAME_SIZE/2);
for frameNo = 1:numFrames
    
    coeff = dequantizeLPC(encodedCoeff(frameNo,:));
    coeff = rc2poly(coeff);
    %coeff = rc2poly(encodedCoeff(frameNo,:));
    pitch = encodedPitch(frameNo);
    pwr = encodedPwr(frameNo);
    
    if(encodedPitch(frameNo) ~= 0)
        frameSamp = processVoiced(coeff,pitch, pwr,FRAME_SIZE, NUM_COEFFS);
    else
        frameSamp = processUnvoiced(coeff, pwr,FRAME_SIZE, NUM_COEFFS);
    end
    
    outSamp1 = frameSamp(1:FRAME_SIZE/2) + prevSamp;
    prevSamp = frameSamp(FRAME_SIZE/2+1:end);
    outSamp = [outSamp outSamp1];
end
