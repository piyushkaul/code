FRAME_SIZE = 80;
NUM_COEFFS = 10;

[inSamp,fs,nBits]=wavread('ENcall-11-G.dowk.wav');
%[inSamp,fs,nBits]=wavread('ENcall-5-G.story-bt.wav');

figure; plot(inSamp);
[encodedCoeff, encodedPwr, encodedPitch] = encodeLPC(inSamp,FRAME_SIZE, NUM_COEFFS);
figure; plot(encodedPitch);
figure; plot(encodedPwr);
save('encoded_file','encodedCoeff','encodedPwr','encodedPitch');

outSamp = decodeLPC(encodedCoeff, encodedPwr, encodedPitch,FRAME_SIZE, NUM_COEFFS);
figure; plot(outSamp);
wavwrite(outSamp,fs,nBits,'ENcall-11-G.dowk_out.wav');
%wavwrite(outSamp,fs,nBits,'ENcall-5-G.story-bt_out.wav');