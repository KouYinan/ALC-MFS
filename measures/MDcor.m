function FL = MDcor(train_data, train_Y)
%UNTITLED3 此处提供此函数的摘要
%   此处提供详细说明
train_Y = train_Y';
[~,l] = size(train_Y);
FL = zeros(1,l);
for i = 1:l
    score = helper_distcorr(train_data,train_Y(:,i));
    FL(i) = score;
end
end