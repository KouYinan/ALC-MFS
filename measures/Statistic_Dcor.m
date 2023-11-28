function FL = Statistic_Dcor(train_data, train_Y)
% input dimensional: train_data is NxL; train_Y is LxN
%   此处提供详细说明
train_Y = train_Y';
f = size(train_data, 2);
l = size(train_Y, 2);
FL = zeros(f,l);
parfor i = 1:f
    for j = 1:l
        FL(i,j) = helper_distcorr(train_data(:,i), train_Y(:,j));      %141s
%         FL(i,j) =  bsxfun(@helper_distcorr, train_data(:,i), train_Y(:,j)); %146s
    end
end
end
% helper_distcorr(train_data(:,1:3),train_data(:,4:6))
% helper_distcorr(train_data(:,1:3),train_data(:,4))
% return 的是一个数值
% 说明这个度量方法的输入可以是任意维的