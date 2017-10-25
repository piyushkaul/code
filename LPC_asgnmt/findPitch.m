function    [encodedPitch, pitchDecisions] = findPitch(frameData, pitchDecisions, FRAME_SIZE)

%fiter first
bCoeff = fir1(100,0.25); %for 1KHz filtering

%find clipping Threshold CL1
peakSample1 = abs(max(frameData(1:FRAME_SIZE)));
peakSample2 = abs(max(frameData(2*FRAME_SIZE+1:end)));

clippingThreshold = 0.7 * min(peakSample1,peakSample2);

%clip the signal
for i=1:length(frameData)
    if abs(frameData(i)) < clippingThreshold
        frameTemp(i) = 0;
    elseif frameData(i) > clippingThreshold
        frameTemp(i) = frameData(i) - clippingThreshold;
    else
        frameTemp(i) = frameData(i) + clippingThreshold;
    end
end
frameTemp = sign(frameTemp);
%figure; plot(frameData);
%figure; plot(frameTemp);
%find autocorrelation
for lag=0:160
    corrVal(lag+1) = sum(frameTemp(1:80) .* frameTemp(1+lag:80+lag));
end
%corrVal = xcorr(frameTemp,2*FRAME_SIZE);
%figure; plot(corrVal)
[val,idx] = max(corrVal(10:end));
if val > (0.7 * corrVal(1))
    encodedPitch = idx-1;
else
    encodedPitch = 0;
end
%smoothen
if encodedPitch ~= 0
    %encodedPitch = 30;
    pitchDecisions = [pitchDecisions(2:end) encodedPitch];
    encodedPitch = median(pitchDecisions);
end
   
