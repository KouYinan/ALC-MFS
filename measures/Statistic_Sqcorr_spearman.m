function FL = Statistic_Sqcorr_spearman(train_data,train_Y)
%stat = corr(xs(:),ys(:))^2; % FUCKING THING. This requires the Matlab Statistics Toolbox
%   此处提供详细说明
train_Y = train_Y';
[~,f] = size(train_data);
[~,l] = size(train_Y);
FL = zeros(f,l);
for i = 1:f
    for j = 1:l
        xs_rank = helper_rankorder(train_data(:,i));
        ys_rank = helper_rankorder(train_Y(:,j));
        A = cov(xs_rank,ys_rank)/sqrt(var(xs_rank)*var(ys_rank));
        stat = A(2,1)^2;
        FL(i,j) = stat;
    end
end

end