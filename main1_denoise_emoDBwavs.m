clear all;close all;fclose all;clc;

%%---- directories
noisyTr_dir = '../emoDB_data/wav_noisy/data_train/';
noisyTe_dir = '../emoDB_data/wav_noisy/data_test/';
denoisedTr_dir = '../emoDB_data/wav_denoised/data_train/';
denoisedTe_dir = '../emoDB_data/wav_denoised/data_test/';

%---- get full list of files
noisyTr_files = dir([noisyTr_dir,'*.wav']);
noisyTr_filenames= arrayfun(@(x) x.name,noisyTr_files,'UniformOutput',0);
noisyTe_files = dir([noisyTe_dir,'*.wav']);
noisyTe_filenames= arrayfun(@(x) x.name,noisyTe_files,'UniformOutput',0);
clear noisyTr_files noisyTe_files;

%---- denoise all the files
for jj=1:1:length(noisyTr_filenames)
    fprintf('%d of %d training\n',jj,length(noisyTr_filenames));
    [wav,Fs]=audioread([noisyTr_dir,noisyTr_filenames{jj}]);
    denoise_wav = spectsub(wav, Fs);
    audiowrite([denoisedTr_dir,noisyTr_filenames{jj}], denoise_wav, Fs);
end

for jj=1:1:length(noisyTe_filenames)
    fprintf('%d of %d testing\n',jj,length(noisyTe_filenames));
    [wav,Fs]=audioread([noisyTe_dir,noisyTe_filenames{jj}]);
    denoise_wav = spectsub(wav, Fs);
    audiowrite([denoisedTe_dir,noisyTe_filenames{jj}], denoise_wav, Fs);
end
