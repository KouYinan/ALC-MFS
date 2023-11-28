function FL = MNC(train_data,train_Y)
%   train_data: samples * features
%   train_Y : labels * samples
train_Y = train_Y';
[~,f] = size(train_data);
[~,l] = size(train_Y);
FL = zeros(f,l);
for i = 1:f
    for j = 1:l
        [~,MNCResult] =MI_k_neighbors_Acce(train_data(:,i),train_Y(:,j),'euc',0.8);
        FL(i,j) = MNCResult;
    end
end
end