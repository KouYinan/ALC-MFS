function result = EL_test(test_data, test_target, model, modelparameter, train_data, train_target, cv)

% This function is the training phase of the _multi-label sparse feature selection

%       test_data               - A MxD array, the feature space
%       test_target             - A LxM array, the label space enhance result
%       model                   - The learned model, including sparse matrix and iter times
%       modelparameter          - The parameters structure of model
%
%   and returns,
%       modelparameter          - The test data evaluate results, including
%       Outputs                 - The MxL array, the probability of the ith testing instance belonging to the jCth class is stored in Outputs(j,i)
%       Pre_Labels              - The MxL array, if the ith testing instance belongs to the jth class, then Pre_Labels(j,i) is +1, otherwise Pre_Labels(j,i) is 0
%
%   evaluate metris             - The input dimension is LxM
%---

% [num_test, num_class] = size(test_target);

W = model.w;                                % 参数赋值

Outputs = test_data * W;    % 线性分类器

Threshold = TuneThresholdW3(train_data, train_target, model);

% Pre_Labels = zeros(num_test,num_class);
Pre_Labels =  Outputs >= Threshold;

%---
result(:,1)  = EvaluationAll(Pre_Labels, Outputs, test_target);
fprintf('------------------cv: %d Predict is ending ------------------\n',cv);

% 输出打印和交叉验证的数据保存可以参考readme_MVLD  25行起
end

% HammingLoss,RankingLoss,OneError,Coverage,Average_Precision

function threshold = TuneThresholdW3(train_data, train_target, model)
    Outputs_tr = train_data * model.w;
    [threshold,  ~] = TuneThreshold( Outputs_tr', train_target, 1, 1);
end

% % 交叉验证结果：直接可以用
% % time represent running time
% time = zero(1, modelparameter.cross_num);
% time(1, cv) = toc;
% Avg_Results = PrintAvgResult(cvResult, time, modelparameter.cross_num);



