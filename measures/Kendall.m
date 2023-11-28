function FL = Kendall(train_data,train_Y)
%UNTITLED10 此处提供此函数的摘要
%   此处提供详细说明
train_Y = train_Y';
[~,f] = size(train_data);
[~,l] = size(train_Y);
FL = zeros(f,l);
for i = 1:f
    for j = 1:l
        kendall=corr(train_data(:,i),train_Y(:,j),'type','Kendall' );
        FL(i,j) = kendall;
    end
end
end