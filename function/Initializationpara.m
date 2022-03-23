function [Ktrain,TY,L,num_views]=Initializationpara(X_set,Y, kernel_type, kernel_para)

num_views=length(X_set);
[n,m]=size(Y);
TY=cell(num_views,1);
L=cell(num_views,1);
Ktrain=cell(num_views,1);

options = [];
options.Metric = 'Euclidean';
options.NeighborMode = 'KNN';
options.k = 10;  % nearest neighbor
options.WeightMode = 'HeatKernel';
options.t = 1.0;
for i = 1:num_views
    S = constructW(X_set{i},options);
    L{i,1} = diag(sum(S,2))-S;
    Ktrain{i} = kernelmatrix(kernel_type,X_set{i}',X_set{i}',kernel_para); % n by n, kernel matrix
    TY{i,1}=rand(n,m);
end
end