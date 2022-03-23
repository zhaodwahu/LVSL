
function [model_LVSL] = LVSL( X_set, Y, optmParameter)

    %% optimization parameters
    lambda1          = optmParameter.lambda1;
    lambda2          = optmParameter.lambda2;
    lambda3          = optmParameter.lambda3;
    lambda4          = optmParameter.lambda4;
    lambda5          = optmParameter.lambda5;

    maxIter          = optmParameter.maxIter;
    kernel_para      = optmParameter.kernel_para;
    kernel_type      = optmParameter.kernel_type;

   %% Initialization
    Y=sparse(Y);
    [Ktrain,P,L,num_views]=Initializationpara(X_set,Y, kernel_type, kernel_para);
    W_set = cell(num_views,1);
    PreY  = cell(num_views,1);
    prediction_Loss       = zeros(num_views,1);
    LossW       = zeros(num_views,1);
    theta = ones(num_views,1)/num_views;
    VSLloss=zeros(num_views,1);

    [n,m]=size(Y);
    YTY=Y'*Y;
    C=eye(m,m);
    Y1=zeros(m,m);
    mu=1e-1;
    pho=1.5;
    max_mu=10^6;

%% updating variables...
    iterVal = zeros(1,maxIter);
    for iter=1:maxIter
           if optmParameter.outputthetaQ
               fprintf('- iter - %d/%d\n', iter, maxIter);
           end           
           PTY=zeros(m,m);
            for v=1:num_views
                W_set{v,1}= (theta(v)*Ktrain{v,1} + lambda1*speye(n))\(theta(v)*P{v,1});
                P{v,1}=((theta(v)+lambda4)*speye(n)+theta(v)*lambda3*L{v,1})\(theta(v)*Ktrain{v}*W_set{v}+lambda4*Y*C);
                PTY=PTY+P{v,1}'*Y;

                VSLloss(v,1)=trace((P{v,1}-Y*C)'*(P{v,1}-Y*C));
                PreY{v,1} = Ktrain{v,1}*W_set{v,1};
                prediction_Loss(v,1)=trace((Ktrain{v,1}*W_set{v,1}-P{v,1})'*(Ktrain{v,1}*W_set{v,1}-P{v,1}))+...
                    lambda3*trace(P{v,1}'*L{v,1}*P{v,1});  
                LossW(v,1)=norm(W_set{v,1})^2;
            end

        Z=softth((C+Y1/mu),lambda5/mu);
        C=(num_views*YTY+mu/lambda4*speye(m))\(PTY+mu/lambda4*Z-1/lambda4*Y1);
        Y1 = Y1+ mu*(C-Z);
        mu = min(pho*mu, max_mu);  
        kloss=sum(svd(Z));
        diff = ((theta)')*prediction_Loss/2 + lambda1*sum(LossW)/2 + lambda4*sum(VSLloss)/2 + lambda5*kloss;

        iterVal(iter) = abs(diff);
          %% update theta: Coordinate descent
           if optmParameter.updateTheta == 1
               theta  = updateTheta(theta, lambda2, prediction_Loss);
           end

           if optmParameter.outputthetaQ == 1
               fprintf(' - prediction loss: ');
               for mm=1:num_views
                    fprintf('%e, ', prediction_Loss(mm));
               end
               fprintf('\n - theta: ');
               for mm=1:num_views
                    fprintf('%.3f, ', theta(mm));
               end
               fprintf('\n');
           end
        if abs(diff)<1e-5
            break
        end
    end 
            %% return values
            model_LVSL.W = W_set;
            model_LVSL.PreY = PreY;
            model_LVSL.theta = theta;
            model_LVSL.kernel_para = kernel_para;
            model_LVSL.kernel_type = kernel_type;
            model_LVSL.loss=iterVal;
            model_LVSL.C=C;
end

function [theta_t ] = updateTheta(theta, lambda, q)
    m = length(theta);
    negative = 0;
    theta_t = zeros(m,1);
    
    for i =1:m
       theta_t(i,1) = (lambda+sum(q) - m*q(i))/(m*lambda);
       if theta_t(i,1) < 0
           negative = 1;
           theta_t(i,1) = 0.0000001;
       end
    end
    if negative == 1
       theta_t = theta_t./sum(theta_t);
    end
end


