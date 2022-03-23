
function normdata = normalization(data, type, addEPS)
% Data Normalization
%    Syntax
%
%       normdata = normalization(data, type, addEPS)
%
%    Input 
%       data        - n by d matrix
%       type        - 'minmax',  xij = (xij - min)/(max-min)
%                     'meanstd', xij = (xij - mean)/std
%                     'l2', norm(xi) = 1
%       addEPS      - {0,1}, data + eps
%
%    Output
%       normdata    - Normarlized Data Matrix


    
    if strcmp(type, 'minmax')
        [n,d] = size(data);
        normdata = zeros(n,d);
        for i = 1:d
            minvalue = min(data(:,i));
            maxvalue = max(data(:,i));
            
            normdata(:,i) = (data(:,i) - ones(d,1)*minvalue)./(maxvalue - minvalue);
        end
    elseif strcmp(type, 'meanstd')
        [n,d] = size(data);
        normdata = zeros(n,d);
        for i = 1:d
            meanvalue = mean(data(:,i));
            stdvalue = std(data(:,i));
            
            normdata(:,i) = (data(:,i) - ones(d,1)*meanvalue)./stdvalue;
        end
    elseif strcmp(type, 'l2')
        if addEPS
            data = data + eps;
        end
        normdata = data./repmat(sqrt(sum(data.^2,2)),1,size(data,2));
        normdata = [normdata,ones(size(data,1),1)];
    end


end