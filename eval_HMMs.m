function [pred_labels,test_labels]=eval_HMMs(testing,model)
    test_labels=cell2mat(testing.label)';
    pred_labels=zeros(length(test_labels),1);
    %predication
    disp('classifying ...')
    for i=1:length(test_labels)
        logpro=zeros(1,10);
        for mindex=1:10
            logpro(mindex)=hmmLogprob(model{mindex},testing.feature{i});
        end
        [M,I]=max(logpro);
        pred_labels(i)=I-1;
    end
    disp('Done!')
end