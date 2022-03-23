function [optmParameter,modelparameter] =  initialization
%%%% para   :lambda1, lambda2, lambda3, lambda4, lambda5, kernel_para
%emotions   :10^2,    10^-1,    10^-6,   10^-1,    10^4,    0.4 1e-1
%yeast      :10^2,    10^-1,    10^-1,   10^-1,    10^5,    0.5
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    optmParameter.lambda1       = 10^-1; %% W
    optmParameter.lambda2       = 10^5;%%
    optmParameter.lambda3       = 10^-3;%%
    optmParameter.lambda4       = 10^2;%%
    optmParameter.lambda5       = 10^-3;%%
   
    optmParameter.kernel_para   = [0.4];
    optmParameter.kernel_type   = 'rbf';%%%RBF_kernel
    
    optmParameter.maxIter       = 30;%%
    optmParameter.updateTheta       = 1;
    optmParameter.outputthetaQ      = 1;
    %% Model Parameters
    modelparameter.searchPara         = 0; %
    modelparameter.tuneParaOneTime    = 1;
    modelparameter.normliza           = 1; %
    modelparameter.tuneThresholdType  = 1; % 1:Hloss, 2:Acc, 3:F1, 4:LabelBasedAccuracy, 5:LabelBasedFmeasure, 6:SubACC 
    modelparameter.crossvalidation    = 1; % {0,1}
    modelparameter.cv_num             = 5;
    modelparameter.splitpercentage    = 0.8; %[0,1]
end