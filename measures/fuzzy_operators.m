function [operator_1, operator_2, operator_3, operator_4] = fuzzy_operators(Dcor_result1)
% function operator_1 = fuzzy_operators(Dcor_result1)
% operator_1, 
% operator_2, 
% operator_3, 
% operator_4, 
%   此处提供详细说明
labels = size(Dcor_result1,2);
features = size(Dcor_result1,1);
matrixs = zeros(labels, labels);
% 算子一
%%
% $max{min{ai,bj}}$ 
for i = 1:labels
    ava_matrix = repmat(Dcor_result1(:,i), 1 , labels);
    ava_min_matrix = min(cat(features, Dcor_result1, ava_matrix), [], features);
    matrixs(i,:) = max(ava_min_matrix);
end
matrixs = matrixs - diag(diag(matrixs));    % 主对角值设置为1
matrixs = matrixs + eye(labels,labels);
operator_1 = matrixs;
% 算子二
%%
% $max{ai.*bj}$ 

for i = 1:labels
    ava_matrix = repmat(Dcor_result1(:,i), 1 , labels);
    ava_muli_matrix = ava_matrix.*Dcor_result1;
    matrixs(i,:) = max(ava_muli_matrix);
end
matrixs = matrixs - diag(diag(matrixs));
matrixs = matrixs + eye(labels,labels);
operator_2 = matrixs;
% 算子三
%%
% $min{1, sum(min(ai,bj))}$ 

for i = 1:labels
    ava_matrix = repmat(Dcor_result1(:,i), 1 , labels);
    ava_min2_matrix = min(cat(features, Dcor_result1, ava_matrix), [], features);
    matrixs(i,:) = min(1, sum(ava_min2_matrix));
end
operator_3 = matrixs;
% 算子四
%%
% $min{1, sum{ai.*bj}}$ 

for i = 1:labels
    ava_matrix = repmat(Dcor_result1(:,i), 1 , labels);
    ava_mmin_matrix = ava_matrix.*Dcor_result1;
    matrixs(i,:) = min(1, sum(ava_mmin_matrix));
end
matrixs = matrixs - diag(diag(matrixs));
matrixs = matrixs + eye(labels,labels);
operator_4 = matrixs;
end