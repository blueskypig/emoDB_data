function MFCC=mfcc(nMFCC,signal,FS)

%Implementation of MFCC Feature: use a short-time processing for MFCC feature extraction using
%a window of duration 30ms and overlap of 10ms. Within each window, extract the first 13 
%mel-frequency cepstral coefficients. 

winLen = ceil(FS*0.030); 
winOverlap = ceil(FS*0.01);

winStep=winLen-winOverlap;

frames=floor((length(signal)-winLen)/(winStep)); % speech frames
MFCC=zeros(frames, nMFCC); % MFCC result

% Map linearly spaced triangular windows in mel to frequency

maxM=1000/log10(2)*log10(FS/2./1000+1);    %Max mel
mFTW=zeros(26,513);               %Mel windows
x=1024/27;                      %0+x/2*25+x=512
for i=1:1:26
    cm(i,:)=[(i-1)*x/2+1,(i-1)*x/2+1+(x-1)/2,(i-1)*x/2+x];      %mel windows
end
cmHz=(cm-1)*maxM/512;                              %mel frequency
cfHz=(10.^(cmHz.*log10(2)/1000)-1)*1000;              %frequency map
cf=round(cfHz.*512/FS/2)+1;                       %sample map
for j=1:1:26                                 %Frequency Windows
    for i=cf(j,1):1:cf(j,2)
        mFTW(j,i)=(i-cf(j,1))/(cf(j,2)-cf(j,1));
    end
    for i=cf(j,2)+1:1:cf(j,3)
        mFTW(j,i)=abs(i-cf(j,3))/(cf(j,3)-cf(j,2));
    end
end

for i=1:1:frames
    section=signal(1+(i-1)*winStep:(i-1)*winStep+winLen);
    sFFT=fft(section.*hamming(winLen),1024);   %fft of each frame
    melP=log10(mFTW*abs(sFFT(1:513)).^2); %power in each mel frequency bin
    c=dct(melP);              %dct power
    MFCC(i,:)=c(1:nMFCC);
end

%user code
% d=deltas(MFCC',5);
% dd=deltas(d,5);
% MFCC=[MFCC';d;dd]';


end