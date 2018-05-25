function Acc = func_evalModel(test_dir, model_params)
    
    % get full list of files
    Te_files = dir([test_dir,'*.wav']);
    Te_filenames= arrayfun(@(x) x.name,Te_files,'UniformOutput',0);
    clear Tr_files;
    
    model = model_params{1};
    X_mu = model_params{2};
    X_stdv = model_params{3};
    
    % emoDB label lookup
    labelLetter={'N','W','L','E','A','F','T'};
    % N neutral
    % A	anger	W	Ärger (Wut)
    % B	boredom	L	Langeweile
    % D	disgust	E	Ekel
    % F	anxiety/fear	A	Angst
    % H	happiness	F	Freude
    % S	sadness	T	Trauer

    % for each file, compute mfccs, add to feature matrix, get labels
    MFCCs=[];
    groups=[];
    for jj = 1:1:length(Te_filenames)
        [wav,Fs]=audioread([test_dir,Te_filenames{jj}]);
        MFCC=mfcc(13,wav,Fs);
        MFCCs=[MFCCs;mean(MFCC)];
        groups=[groups;find(strcmp(Te_filenames{jj}(6), labelLetter))];
    end
    
    MFCCs = (MFCCs - ones(size(MFCCs,1),1)*X_mu)./(ones(size(MFCCs,1),1)*X_stdv);
    
    % evaluate with the built-in multinomial logistic regression model
    groups_predprob = mnrval(model, MFCCs);
    [m,groups_pred] = max(groups_predprob,[],2);
    confumat = confusionmat(groups, groups_pred);
    UAR = mean(diag(confumat)./sum(confumat,2));
    Acc = sum(diag(confumat))./sum(sum(confumat));
end