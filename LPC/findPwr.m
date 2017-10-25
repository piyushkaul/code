function [encodedPwr] = findPwr(frameData)

encodedPwr = 10 * log10(sqrt(sum(frameData.^2))/length(frameData));