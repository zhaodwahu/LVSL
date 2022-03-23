clear;clc
addpath(genpath('.'));
load('yeast.mat')
starttime = datestr(now,0);
fprintf('Start Run LVSL at time:%s \n',starttime);
%% Initialization
[optmParameter,modelparameter] =  initialization;
time = zeros(1,modelparameter.cv_num);
num_views=length(dataMVML);

%% Procedures of Training and Test for LVSL
fprintf('Running LVSL\n');  
num_data = size(dataMVML{1},1);
% randorder = randperm(num_data);
if modelparameter.normliza==1
    for i = 1:num_views
        dataMVML{i} = normalization(dataMVML{i}, 'l2', 1);
    end
end

cvResult  = cell(modelparameter.cv_num,1);
models = cell(modelparameter.cv_num,1);
cv_num=modelparameter.cv_num;
   
for cv = 1:cv_num
    fprintf('Cross Validation - %d/%d\n', cv, cv_num);
    s = RandStream.create('dsfmt19937','seed',cv);
    RandStream.setGlobalStream(s);
    randorder = randperm(num_data);
    [cvTrainSet,cvTrain_target,cvTestSet,cvTest_target ] = generateMultiViewCVSet(dataMVML, target, randorder, cv, modelparameter.cv_num);
    train_index=1:size(cvTrain_target,1);
    tic
    cvLVSL   = LVSL(cvTrainSet, double(cvTrain_target), optmParameter);
    fprintf('\nMulti-view multi-label classification results:\n---------------------------------------------\n');
    cvResult{cv} = LVSL_Predict(cvTestSet, cvTest_target', cvLVSL, modelparameter, cvTrainSet, cvTrain_target');
    time(1,cv) = toc;
end
[Avg_Result, averagetime] = PrintLVSLAvgResult(cvResult, time, modelparameter.cv_num);
model_LVSL.randorder = randorder;
model_LVSL.optmParameter = optmParameter;
model_LVSL.modelparameter = modelparameter;
model_LVSL.cvResult = cvResult;
model_LVSL.avg_Result = Avg_Result;
model_LVSL.averagetime = averagetime;

endtime = datestr(now,0);
fprintf('End Run LVSL at time:%s \n',endtime);
rmpath(genpath('.'));
beep;
