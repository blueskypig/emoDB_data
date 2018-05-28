function train_model(nstate,training)
%     %paramter
%     d=size(training.feature{1},1);
%     prior.mu = ones(1, d);
%     prior.Sigma = 0.1*eye(d);
%     prior.k = d;
%     prior.dof = prior.k + 1;

    %Train HMMs
    disp('traing....');
    train_labels=cell2mat(training.label)';
    model=cell(1,10);
    for mindex=1:10
        %get train samples for each digit
        dindex=find(train_labels==(mindex-1));
        train_data=cell(length(dindex),1);
        for i=1:length(dindex)
            train_data{i}=training.feature{dindex(i)};
        end
        model{mindex}=hmmFitEm(train_data, nstate, 'gauss', 'verbose', true);
        %model{mindex}=hmmFit(train_data,nstate,'mixGaussTied');
    end
    %save model
    save HMMs_model model
    disp('Done!');
end
