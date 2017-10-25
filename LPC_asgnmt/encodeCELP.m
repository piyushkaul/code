function [encodedCoeff, encodedPwr, encodedPitch, resIdx, codebook] = encodeCELP(inSamp, FRAME_SIZE, NUM_COEFFS)

lengthSamples = length(inSamp);
numFrames = floor(lengthSamples/FRAME_SIZE) * 2;
pitchDecisions = zeros(1,5);

arCoeffs = zeros(NUM_COEFFS+1,1);
%rcCoeffs = zeros(1,NUM_COEFFS);
encodedCoeff = zeros(numFrames,NUM_COEFFS);
residualVal = zeros(numFrames,FRAME_SIZE);
length(inSamp);

prevPrevFrameData = zeros(FRAME_SIZE,1);
prevFrameData = zeros(FRAME_SIZE,1);

for frameNo = 1:numFrames
    
    offset = (frameNo-1)*FRAME_SIZE/2;
    frameData = inSamp(offset+1:offset + FRAME_SIZE);
    [arCoeffs,residual] = findLPCoeffs(frameData,NUM_COEFFS);
    residualVal(frameNo,:) = residual';  
    encodedCoeff(frameNo,:) = poly2rc( arCoeffs)';
    [encodedPitch(frameNo), pitchDecisions] = findPitch([prevPrevFrameData; prevFrameData ;frameData], pitchDecisions, FRAME_SIZE);
    encodedPwr(frameNo) = findPwr(frameData);

    prevPrevFrameData = prevFrameData;
    prevFrameData = frameData;
    
end


arCoeffs = zeros(NUM_COEFFS+1,1);
%rcCoeffs = zeros(1,NUM_COEFFS);
encodedCoeff = zeros(numFrames,NUM_COEFFS);
residualVal = zeros(numFrames,FRAME_SIZE);
length(inSamp);

prevPrevFrameData = zeros(FRAME_SIZE,1);
prevFrameData = zeros(FRAME_SIZE,1);

for frameNo = 1:numFrames
    coeff = rc2poly(encodedCoeff(frameNo,:));
    pitch = encodedPitch(frameNo);
    pwr = encodedPwr(frameNo);
    res = zeros(1,FRAME_SIZE);
    
    if(encodedPitch(frameNo) ~= 0)
        frameSamp = processVoicedCodebook(coeff,pitch, pwr, res,FRAME_SIZE, NUM_COEFFS);
    else
        frameSamp = processUnvoiced(coeff, pwr,FRAME_SIZE, NUM_COEFFS);
    end
    
    offset = (frameNo-1)*FRAME_SIZE/2;
    frameData = inSamp(offset+1:offset + FRAME_SIZE);
    
    residualData(frameNo,:) = frameData' - frameSamp;
end

%create codebook
%residual
[resIdx, codebook] = kmeans(residualData,64);
