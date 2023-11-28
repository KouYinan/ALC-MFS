function FL = Statistic_Hoeffding(train_data,train_Y)
%UNTITLED8 此处提供此函数的摘要
%   此处提供详细说明
train_Y = train_Y';
[~,f] = size(train_data);
[~,l] = size(train_Y);
FL = zeros(f,l);
for i = 1:f
    for j = 1:l
        stat = helper_hoeffdingsD(train_data(:,i),train_Y(:,j));
        FL(i,j) = stat;
    end
end
end