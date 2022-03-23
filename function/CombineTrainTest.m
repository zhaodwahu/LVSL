function MultiViewData = CombineTrainTest(Train_set, Test_set, num_views)
    MultiViewData = cell(num_views,1);
    for i = 1:num_views
       MultiViewData{i} = double([Train_set{i};Test_set{i}]);
    end
end