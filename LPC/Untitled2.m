lengthSamples = length(inSamp);
numFrames = lengthSamples/FRAME_SIZE * 2;

arCoeffs = zeros(numFrames,NUM_COEFFS);
larCoeffs = zeros(numFrames,NUM_COEFFS);
for frameNo = 1:numFrames
    offset = (numFrames-1)*FRAME_SIZE/2 + 1;
    frameData = inSamp(offset ,offset + FRAME_SIZE);
    arCoeffs = lpc(frameData,10);
    larCoeffs = ar2lar(coeffs);
end
