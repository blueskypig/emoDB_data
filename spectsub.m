function denoise_wav = spectsub(wav, Fs)

    %---- set window length to 30 ms with a 15ms window shift
    winLen = ceil(Fs*0.030);
    winShift = ceil(Fs*0.015); 
    hWin = sqrt(hamming(winLen));
    hWin = hWin/mean(hWin)/sqrt(2); % normalize window in attempt to make output energy 1 if no noise case

    %---- get the noisy sample from the last 0.25s of the audio file
    noiseSeg = wav(end-Fs*0.25:end);
    
    %---- buffer wav and take the fft
    wav_buff = buffer(wav, winLen, winLen-winShift);
    wav_buff = wav_buff .* (hWin*ones(1,size(wav_buff,2)));
    fft_buff = fft(wav_buff);
    absfft_buff = abs(fft_buff);
    %---- buffer noiseSeg and take the fft
    noiseSeg_buff = buffer(noiseSeg,winLen,winLen-winShift);
    noiseSeg_buff = noiseSeg_buff.* (hWin*ones(1,size(noiseSeg_buff,2)));
    noise_fft_buff = fft(noiseSeg_buff);
    absnoise_fft_buff = mean(abs(noise_fft_buff),2); % take mean across time
    
    %---- spectral subtract the noise
    % instead of straight subtraction, we will calculate the effective gain
    denoise_absfft_buff = (absfft_buff - absnoise_fft_buff * ones(1,size(absfft_buff,2)));
    denoise_absfft_buff=max(0,denoise_absfft_buff); % ensure there are no negative values of denoise_absfft_buff
    g=denoise_absfft_buff./absfft_buff;
    g=min(1,g);% cap the gain at 1
    
    %---- denoise the wav signals
    denoise_wav=zeros((size(fft_buff,2)-1)*winShift + winLen,1);
    for jj = 1:1:size(fft_buff,2)
        denoise_wav(1+(jj-1)*winShift:(jj-1)*winShift+winLen) = denoise_wav(1+(jj-1)*winShift:(jj-1)*winShift+winLen) + ifft(fft_buff(:,jj).*g(:,jj)).*hWin;
    end

end