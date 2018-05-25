function [model_params] = func_trainModel(train_dir)
    
    % get full list of files
    Tr_files = dir([train_dir,'*.wav']);
    Tr_filenames= arrayfun(@(x) x.name,Tr_files,'UniformOutput',0);
    clear Tr_files;
    
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
    for jj = 1:1:length(Tr_filenames)
        [wav,Fs]=audioread([train_dir,Tr_filenames{jj}]);
        MFCC=mfcc(13,wav,Fs);
        MFCCs=[MFCCs;mean(MFCC)];
        groups=[groups;find(strcmp(Tr_filenames{jj}(6), labelLetter))];
    end
    X_mu = nanmean(MFCCs);
    X_stdv = nanstd(MFCCs);
    
    MFCCs = (MFCCs - ones(size(MFCCs,1),1)*X_mu)./(ones(size(MFCCs,1),1)*X_stdv);
    
    % this is a built-in multinomial logistic regression model
    model = mnrfit(MFCCs, groups);
    
    model_params = {model, X_mu, X_stdv};

end