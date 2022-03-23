
function result = LVSL_Predict(Xtest_set, Ytest, model_LVSL, modelparameter, Xtrain_set, Ytrain)
    num_views = size(Xtest_set,1);
    [num_class,num_test] = size(Ytest);
    result = zeros(5,1);
    LVSL_funsion_outputs = zeros(num_class,num_test);
    kernel_para=model_LVSL.kernel_para;
    kernel_type=model_LVSL.kernel_type;
    W=model_LVSL.W;
    theta=model_LVSL.theta;
    for i = 1:num_views
        Ktest = kernelmatrix(kernel_type,Xtest_set{i}',Xtrain_set{i}',kernel_para); 
        Outputs=(Ktest * W{i});
        Outputs      = Outputs';
        LVSL_funsion_outputs    = LVSL_funsion_outputs + theta(i).*Outputs;
    end
   %% funsion
    threshold = tuneThresholdMVML(Xtrain_set, Ytrain, model_LVSL, modelparameter);
    Pre_Labels   = LVSL_funsion_outputs >= threshold(1,1); 
    Pre_Labels   = double(Pre_Labels);
    result(:,1)  = EvaluationAll(Pre_Labels,LVSL_funsion_outputs,Ytest);
end

function threshold = tuneThresholdMVML(Xtrain_set, Ytrain, model_LVSL, modelparameter)
    num_views = size(Xtrain_set,1);
    LVSL_funsion_outputs = zeros(size(Ytrain'));
    PreY=model_LVSL.PreY;
    theta=model_LVSL.theta;
    tuneThresholdType=modelparameter.tuneThresholdType;
    for i = 1:num_views    
        Outputs= PreY{i};
        LVSL_funsion_outputs  = LVSL_funsion_outputs + Outputs*theta(i);
    end
    [ threshold,  ~] = TuneThreshold( LVSL_funsion_outputs', Ytrain, 1, tuneThresholdType);
end