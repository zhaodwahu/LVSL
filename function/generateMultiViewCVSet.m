function [cvTrainSet,cvTrain_target,cvTestSet,cvTest_target ] = generateMultiViewCVSet(data,target,randorder,num_currentFold, num_cv)
% Generate cv training data test set for multi-view multi-label data
%
% Syntax
%       [cvTrainSet,cvTrain_target,cvTestSet,cvTest_target ] = generateMultiViewCVSet( data,target,randorder,num_currentFold, num_cv)
%
% Input
%   data            - num_views by 1 cell set, each element is a n by di data matrix
%   target          - n by l label matrix
%
% Output
%   cvTrainSet      - num_views by 1 cell set, each element is a num_train by di data matrix
%   cvTrain_target  - num_train by l label matrix
%   cvTestSet       - num_views by 1 cell set, each element is a num_test by di data matrix
%   cvTest_target   - num_test by l label matrix


	num_views = size(data,1);
    cvTrainSet = cell(num_views,1);
    cvTestSet = cell(num_views,1);
    
    for i =1:num_views
        [cv_train_data,cv_train_target,cv_test_data,cv_test_target ] = generateCVSet(data{i},target,randorder,num_currentFold,num_cv);
        cvTrainSet{i} = cv_train_data;
        cvTrain_target = cv_train_target;
        
        cvTestSet{i} = cv_test_data;
        cvTest_target = cv_test_target;
    end
    
end