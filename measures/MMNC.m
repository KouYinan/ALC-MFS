function FL = MMNC(train_data,train_Y)
%UNTITLED2 此处提供此函数的摘要
%   此处提供详细说明
train_Y = train_Y';
[~,l] = size(train_Y);
FL = zeros(1,l);
for i = 1:l
    [~,MNCResult] =MI_k_neighbors_Acce(train_data,train_Y(:,i),'euc',0.8);
    FL(i) = MNCResult;
end
end