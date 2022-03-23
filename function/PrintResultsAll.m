
function PrintResultsAll(Result,tags)
fprintf('\n--------------------------------------------\n');
fprintf('Evalucation Metric       Mean      Std\n');
fprintf('--------------------------------------------\n');
num_views = -1;
num_tags = size(tags,1);
fprintf('                      ');
for i = 1:num_tags
   fprintf(['   ', tags{i},'\t\t ']);
end

fprintf('\n--------------------------------------------\n');
fprintf('Average_Precision     ');
for i = 1:(num_views+2)*2
    fprintf('   %.4f',Result(1,i));
end


fprintf('\rHammingLoss           ');
for i = 1:(num_views+2)*2
    fprintf('   %.4f',Result(2,i));
end


fprintf('\rOneError              ');
for i = 1:(num_views+2)*2
    fprintf('   %.4f',Result(3,i));
end

fprintf('\rRankingLoss           ');
for i = 1:(num_views+2)*2
    fprintf('   %.4f',Result(4,i));
end

fprintf('\rCoverage              ');
for i = 1:(num_views+2)*2
    fprintf('   %.4f',Result(5,i));
end
fprintf('\n');
end