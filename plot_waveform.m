clear all;close all;fclose all;clc;

%%---- directories
origTr_dir = '../emoDB_data/wav_orig/data_train/';
origTe_dir = '../emoDB_data/wav_orig/data_test/';
noisyTr_dir = '../emoDB_data/wav_noisy/data_train/';
noisyTe_dir = '../emoDB_data/wav_noisy/data_test/';
denoisedTr_dir = '../emoDB_data/wav_denoised/data_train/';
denoisedTe_dir = '../emoDB_data/wav_denoised/data_test/';

name='03a01Fa.wav';
% original
figure
[s,Fs]=audioread([origTr_dir,name]);
n=linspace(0,length(s)/Fs,length(s))';
plot(n,s);title('original');
xlabel('second/s')
figure
spectrogram(s,30);
title('original');

% nosiy
figure
[s,Fs]=audioread([noisyTr_dir,name]);
n=linspace(0,length(s)/Fs,length(s))';
plot(n,s);title('noisy');
xlabel('second/s')
figure
spectrogram(s,30);
title('noisy');

% denoised
figure
[s,Fs]=audioread([denoisedTr_dir,name]);
n=linspace(0,length(s)/Fs,length(s))';
plot(n,s);title('denoised');
xlabel('second/s')
figure
spectrogram(s,30);
title('denoised');