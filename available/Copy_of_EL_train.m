function model = EL_train(train_data, train_Y, label_corr, modelparameter, cv)

% This function is the training phase of the _multi-label sparse feature selection

%       train_data              - A NxD array, the feature space
%       train_Y                 - A NxL array, the label space enhance result
%       label_corr              - A LxL array, the global and local label correlation
%       modelparameter          - The parameters structure of model
%       mu,alpha                - The regulization parameters
%       eta                     - The learn rate
%       p                       - The parameter of sparse p
%       err                     - The second terminal condition, maxIter is the first terminal condition
%       W                       - The dimension is DxL, the sparse feature matrix
%
%   and returns,
%       model                   - The learned model

mu = modelparameter.mu;
alpha = modelparameter.alpha;
lambda = modelparameter.lambda;
eta = modelparameter.eta;
maxIter = modelparameter.maxIter;
p = modelparameter.p;
err = modelparameter.err;

model = [];

[num_train, dim] = size(train_data);
[~, num_label] = size(train_Y);

iter = 1;

I = eye(num_train);
P = inv(mu*I + I);
A = train_data' * (mu * I - mu*mu*P') * train_data;
% U = diag_U(train_data, train_Y, W);
% B = mu * train_data' * P * train_Y;

% W = rand(dim, num_label);
W = inv(train_data' * train_data + 0.1 * eye(dim)) * train_data' * train_Y;

y_current = train_data * W;

iter_grad = cell(maxIter,1);

while iter <= maxIter
    D = diag_D(W, p);    
%     f_diff = A * W - B + alpha * W *label_corr + (p/2)*lambda * D * W;

%   computing gradient
    f_diff = A * W - (mu/2) * train_data' * (P'+P)* train_Y + (alpha/2) * W * (label_corr' + label_corr) + (p/2)*lambda*D*W;
%   updata                              
    W_temp = W - eta * f_diff;
    y_temp = train_data * W_temp;

%     iter_grad{iter,1} = W_temp;
%     iter_grad{iter,1} = norm(W_temp);

%     iter_err(iter) = norm(y_current - y_temp,2);
%     iter_err(iter) = sum(sum(abs(y_current - y_temp)));
%     y_current = y_temp;
%     iter_err(iter) = norm(f_diff,2);

%     iter_err(iter) = norm(y_current - y_temp,2);
    iter_err(iter) = abs(sum(sum(y_current - y_temp)));
    y_current = y_temp;
%     iter_err(iter) = sum(sum(abs(W - W_temp)));
%     iter_err(iter) = (norm(y_current - train_data*W_temp)/norm(y_current))^2;

%     iter_err(iter) = (norm(y - train_data*W_temp)/norm(y))^2;
%     iter_err(iter) = norm(W - W_temp,2);
%     iter_err = abs(sum(sum(W-W_temp)));
%     disp(iter_err);

%     if iter_err(iter) < err
%         W = W_temp;
%         break
%     end
    iter = iter + 1;
    W = W_temp;
end

model.w = W;
model.iter = iter;
model.gradient = iter_err;
% model.gradient = iter_grad;


fprintf('------------------cv: %d Training is ending ------------------\n',cv);
end

% The convex function of l2,p-norm 
function D = diag_D(W, p)
%  
[num_row, ~] = size(W);
D = eye(num_row);
for i=1:num_row
    D(i,i) = p/2 * norm(W(i,:), 2)^(2-p);
end
end

function U = diag_U(train_data, train_Y, W)
    num_data = size(train_data,1);    
    U = zeros(num_data);
    for i = 1:num_data
        U(i,i) = 1/(norm(train_data(i,:)*W - train_Y(i,:),2));
    end
end