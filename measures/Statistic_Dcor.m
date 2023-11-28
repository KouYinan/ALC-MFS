function FL = Statistic_Dcor(train_data, train_Y)
% input dimensional: train_data is NxL; train_Y is LxN

train_Y = train_Y';
f = size(train_data, 2);
l = size(train_Y, 2);
FL = zeros(f,l);
parfor i = 1:f
    for j = 1:l
        FL(i,j) = helper_distcorr(train_data(:,i), train_Y(:,j));
    end
end
end
