function FL = Mic(train_data,train_Y)
%   Mic的计算要将向量转成行向量计算
%   train_data: samples * features
%   train_Y : labels * samples
train_Y = train_Y';
[~,f] = size(train_data);
[~,l] = size(train_Y);
FL = zeros(f,l);
parfor i = 1:f
    for j = 1:l
        [mic,~] = mine(train_data(:,i)',train_Y(:,j)');  % 这两个输入必须是行向量
        FL(i,j) = mic.mic;
    end
end
end