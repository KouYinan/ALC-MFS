function label_corr = LabelCorr(train_data, train_Y, modelparameter)

% goal: obtain the gobal label correlation and local label correlation

% -------- global correlation -----
% The correlation of feature and label

% corr_result = Mic(train_data, train_Y);
corr_result = Statistic_Dcor(train_data, train_Y);

% %   1.Spearman---------------------------
% corr_result = Statistic_Sqcorr_spearman(train_data, train_Y);
% %   2.Dcor-------------------------------
% Dcor_result = Statistic_Dcor(train_data, train_Y);%运行           费时
% %   3.Hoeffding's D----------------------
% Hoeffding_result = Statistic_Hoeffding(train_data,train_Y);
% %   4.Pearson----------------------------
% corr_result = Pearson(train_data, train_Y);
% %   5.Kendall----------------------------
% Kendall_result = Kendall(train_data,train_Y);
% %   6.Mic--------------------------------
% corr_result = Mic(train_data,train_Y);
% %   7.MNC--------------------------------
% corr_result = MNC(train_data,train_Y);


% The fuzzy integral of label correlation
corr_global = fuzzy_integral(corr_result);

% -------- local correlation -----
[cidxCos, k] = ClusterCos(train_data, modelparameter);
[localdata, localtarget] = localSamples(cidxCos, train_data, train_Y, k);

% method 1:
% [~, corr_local] = localcorr(localdata, localtarget);
% 
% method 2:
% the input of Statistic_Dcor (LxM)
[~, corr_local] = localcorrDcor(localtarget,localtarget);
corr_local = corr_local./k;
% -------- label correlation intergration ---------
%   The operator ; here, simplify, we use add
label_corr = corr_global + corr_local;

% -------- Futher process --------------
% % The diag value is 1
diag_ele = diag(label_corr);
label_corr = label_corr + diag(diag_ele)*(-1) + eye(size(train_Y,1));

end

function [local, corr_local] = localcorrDcor(data,target)
    [num_label,~] = size(target{1,1});
    [num_local,~] = size(data);
    local  = cell(num_local,1);
    for i = 1:num_local
        local_c_temp = Statistic_Dcor(data{i,1}',target{i,1});
        local_c_temp(find(isnan(local_c_temp)==1)) = 0; % NaN 替换为0
        local{i,1} = local_c_temp;
    end
    corr_local = zeros(num_label);
    for j = 1:num_local
        corr_local = corr_local + local{j,1};
    end
end

function [local, corr_local] =  localcorr(data, target)
    [num_label,~] = size(target{1,1});
    [num_local,~] = size(data);
    local  = cell(num_local,2);
    for i = 1:num_local
        local_c_temp = Mic(data{i,1}, target{i,1});
        local_f_temp = fuzzy_integral(local_c_temp);
        local{i,1} = local_c_temp;
        local{i,2} = local_f_temp;
    end
    corr_local = zeros(num_label);
    for j = 1:num_local
        corr_local = corr_local + local{j,2};
    end
end

% Obtain local samples
function [localdata, localtarget] = localSamples(cidxCos, train_data, train_Y, k)
    localdata = cell([k,1]);
    localtarget = cell([k,1]);
    for i = 1:k
        idxtemp = find(cidxCos==i);
        localdata{i,1} = train_data(idxtemp,:);
        localtarget{i,1} = train_Y(:,idxtemp);
    end
end

% 确定聚类个数和样本索引
function [cidxCos, k_] = ClusterCos(train_data, modelparameter)
    k_ = ParameterK(train_data, modelparameter);
%     [cidxCos, ~] = kmeans(train_data, k_, "Distance", 'cosine');
    [cidxCos, ~] = kmeans(train_data, k_);
    color = [1,0,0; 1,0.5,0; 1,0.84,0;1,1,0;0.67,1,0.18;0,1,0.5;0,1,0;0,1,1;0,0.75,1;0.12,0.56,1;0,0,1;0.48,0.40,0.93; 0.63,0.13,0.94;1,0,1;1,0.07,0.57];
%     Y1 = tsne(train_data,'Algorithm','exact','Distance','cosine');
    Y1 = tsne(train_data,'Algorithm','exact');
    f1 = figure;
    gscatter(Y1(:,1),Y1(:,2),cidxCos,color);% 展示tsne降维效果
    
%     savename = [modelparameter.datasetname '_' 'tsne' '_' num2str(modelparameter.cv) '.pdf'];
%     saveas(f1, savename);
%     cd ..\
    close all;
end

% 确定聚类个数
function K_ = ParameterK(train_data, modelparameter)
    K = modelparameter.K; D=zeros(K,2);
    for k=2:K   
%         [lable,c,sumd,d] = kmeans(train_data,k,"Distance",'cosine');% cosine、sqeuclidean
        [lable,c,sumd,d] = kmeans(train_data,k);
        % data，n×p原始数据向量    % lable，n×1向量，聚类结果标签；    % c，k×p向量，k个聚类质心的位置
        % sumd，k×1向量，类间所有点与该类质心点距离之和    % d，n×k向量，每个点与聚类质心的距离
        sse1 = sum(sumd.^2);
        D(k,1) = k;
        D(k,2) = sse1;
    end
    f2 = figure;
    plot(D(2:end,1),D(2:end,2))
    hold on;
    plot(D(2:end,1),D(2:end,2),'or');
    hold off;
    title('不同K值聚类偏差图') 
    xlabel('分类数(K值)') 
    ylabel('簇内误差平方和or余弦距离') 
    grid on;

%     cd figures\
%     savename2 = [modelparameter.datasetname '_' 'K' '_' num2str(modelparameter.cv) '.pdf'];
%     saveas(f2, savename2);
    
    margin_values = [];
    for i = 2:size(D,1)-1
        margin_values = [margin_values D(i,2)-D(i+1,2)];
    end
    value = median(margin_values);
    % values = sort(margin_values, 'descend');
    [~,K_] = find(margin_values==value);
    fprintf('----------   The value of culster size K_: %d \n',K_);
end

% RKF = [1, 0.3152, 0.3152;0.3152, 1, 0.3808;0.3262, 0.3808, 1];