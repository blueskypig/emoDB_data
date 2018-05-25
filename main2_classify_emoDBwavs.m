clear all;close all;fclose all;clc;

%%---- directories
origTr_dir = '../emoDB_data/wav_orig/data_train/';
origTe_dir = '../emoDB_data/wav_orig/data_test/';
noisyTr_dir = '../emoDB_data/wav_noisy/data_train/';
noisyTe_dir = '../emoDB_data/wav_noisy/data_test/';
denoisedTr_dir = '../emoDB_data/wav_denoised/data_train/';
denoisedTe_dir = '../emoDB_data/wav_denoised/data_test/';

%%---- Train models (this should take about 25 seconds per model)
%-- you will get warnings, ignore these. they are occuring because we
%should be more careful in preparing our features
%-- for each file in list: extract mfccs, take average, add to the training matrix
% train ORIG model
fprintf('Training model on original data....\n');
orig_model = func_trainModel(origTr_dir);
% train NOISY model
fprintf('Training model on noisy data....\n');
noisy_model = func_trainModel(noisyTr_dir);
% train DENOISED model
fprintf('Training model on denoised data....\n');
denoised_model = func_trainModel(denoisedTr_dir);
fprintf('Model training has completed.\n\n')

%%---- Test models
fprintf('Testing all models with unweighted average recall (UAR)\nBaseline UAR = 1/7 (1/#-of-classes)\n\n')
models = {'orig_model', 'noisy_model', 'denoised_model'};
for model_name = models
    fprintf('Trained model: %s\n',model_name{:});
    eval(sprintf('model = %s;', model_name{:}));
    
    fprintf('\teval data -- orig: ');
    Acc = func_evalModel(origTe_dir, model);
    fprintf('Acc=%0.1f%%\n', Acc*100);
    
    fprintf('\teval data -- noisy: ');
    Acc = func_evalModel(noisyTe_dir, model);
    fprintf('Acc=%0.1f%%\n', Acc*100);
    
    fprintf('\teval data -- denoised: ');
    Acc = func_evalModel(denoisedTe_dir, model);
    fprintf('Acc=%0.1f%%\n', Acc*100);
    
end