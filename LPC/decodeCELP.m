function [outSamp] = decodeCELP(encodedCoeff, encodedPwr, encodedPitch,  resIdx, codebook, FRAME_SIZE, NUM_COEFFS)

numFrames = length(encodedPwr);

outSamp = [];
frameSamp = [];

prevSamp = zeros(1,FRAME_SIZE/2);
for frameNo = 1:numFrames
    
    coeff = rc2poly(encodedCoeff(frameNo,:));
    pitch = encodedPitch(frameNo);
    pwr = encodedPwr(frameNo);
    res = codebook(resIdx(frameNo),:);
    
    if(encodedPitch(frameNo) ~= 0)
        frameSamp = processVoicedCodebook(coeff,pitch, pwr, res,FRAME_SIZE, NUM_COEFFS);
    else
        frameSamp = processUnvoiced(coeff, pwr,FRAME_SIZE, NUM_COEFFS);
    end
    
    outSamp1 = frameSamp(1:FRAME_SIZE/2) + prevSamp;
    prevSamp = frameSamp(FRAME_SIZE/2+1:end);
    outSamp = [outSamp outSamp1];
end
