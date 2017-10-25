FRAME_SIZE = 80;
NUM_COEFFS = 10;

[inSamp,fs,nBits]=wavread('ENcall-11-G.dowk.wav');
figure; plot(inSamp);



%encode CELP
[encodedCoeff, encodedPwr, encodedPitch, resIdx, codebook] = encodeCELP(inSamp,FRAME_SIZE, NUM_COEFFS);


%plot encoded data
figure; plot(encodedPitch);
figure; plot(encodedPwr);

%decode
outSamp = decodeCELP(encodedCoeff, encodedPwr, encodedPitch, resIdx, codebook, FRAME_SIZE, NUM_COEFFS);

%plot output
figure; plot(outSamp);

%write to file
wavwrite(outSamp,fs,nBits,'ENcall-11-G_dowk_out_celp.wav');