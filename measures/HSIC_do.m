function FL = HSIC_do(train_data,train_Y)
%UNTITLED 此处提供此函数的摘要
%   此处提供详细说明
train_Y = train_Y';
[~,l] = size(train_Y);
FL = zeros(1,l);
for i = 1:l
    score = HSIC(train_data, train_Y(:,i));
    FL(i) = score;
end
end