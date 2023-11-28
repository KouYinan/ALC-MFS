function result = cos_similar(train_data)
%UNTITLED 此处提供此函数的摘要
%   此处提供详细说明
%%
% $CS(A,B) = \frac{A\cdot B}{\left\|A\right\| \left\|B\right\|}$ 

normA = sqrt(sum(train_data.^2,2));
normB = sqrt(sum(train_data'.^2,1));
result = bsxfun(@rdivide,bsxfun(@rdivide,train_data*train_data',normA),normB);
end