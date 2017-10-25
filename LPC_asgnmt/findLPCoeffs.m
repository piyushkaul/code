function  [lpCoeffs, res] = findLPCoeffs(inFrame,order)

lpCoeffs = real(lpc(inFrame,order));
outFrame = filter(1,lpCoeffs,inFrame);
res = inFrame - outFrame;