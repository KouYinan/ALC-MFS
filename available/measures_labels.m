% 度量数据集的标记相关性---线性/非线性表现形式---分析Cor-将Cor作为先验信息输入
%% ----------------------------------------------------------------------------------------------------------------
% 在源数据上操作---不标准化数据、不增强标记数据
clear clc;
load 'Birds.mat';
dataname = 'Birds';
% modelparameter =  Initialization;
test_target(find(test_target==-1))=0;train_target(find(train_target==-1))=0;
test_target = double(test_target);train_target = double(train_target);
data = [train_data; test_data];target = double([train_target,test_target]);
clear train_data test_data train_target test_target

[DN,~] = size(data);[~,TN] = size(target);
cross_num = modelparameter.cross_num;
indices = crossvalind('Kfold', DN, cross_num);
% for i = 1:cross_num
test = (indices ==1);train = ~test;
test_data = data(test,:);test_target = target(:,test);
train_data = data(train,:);train_target = target(:,train);
% [train_data, test_data] = Stand(train_data,test_data);

Spearman_result = Statistic_Sqcorr_spearman(train_target', train_target);
Dcor_result = Statistic_Dcor(train_target', train_target);
Hoeffding_result = Statistic_Hoeffding(train_target', train_target);
Pearson_result = Pearson(train_target', train_target);
Kendall_result = Kendall(train_target', train_target);
Mic_result = Mic(train_target', train_target);
% MNC_result = MNC(train_target', train_target);

% 将计算的相关性的结果保存到本地---前六个
Plot_data = {Spearman_result, Dcor_result, Hoeffding_result, Pearson_result, Kendall_result, Mic_result};
savepath = ['G:\研究生研究内容\Work3\临时数据存放\', dataname, '_Labels_Cor_results.mat'];
save(savepath, "Plot_data");
Plot_titles = {'Spearman','Dcor','Hoeffding','Pearson','Kendall','Mic'};
% 将多个结果绘制到一个图形中(多个子图)
for i=1:size(Plot_titles,2)
    subplot(ceil(size(Plot_titles,2)/2),2,i);
    heatmap(Plot_data{i},'Title',Plot_titles{i});
end
% 单图绘制：
heatmap(Spearman_result,'Title','Spearman');


%% ----------------------------------------------------------------------------------------------------------------
% 在处理后的数据上操作---标准化数据、增强标记数据
clear;clc;
load 'Yeast.mat';
dataname = 'Yeast';
modelparameter =  Initialization;
test_target(find(test_target==-1))=0;train_target(find(train_target==-1))=0;
test_target = double(test_target);train_target = double(train_target);
data = [train_data; test_data];target = double([train_target,test_target]);
clear train_data test_data train_target test_target

[DN,~] = size(data);[~,TN] = size(target);
cross_num = modelparameter.cross_num;
indices = crossvalind('Kfold', DN, cross_num);
% for i = 1:cross_num
test = (indices ==1);train = ~test;
test_data = data(test,:);test_target = target(:,test);
train_data = data(train,:);train_target = target(:,train);
% [train_data, test_data] = Stand(train_data,test_data);        % 数据标准化

en_local = Local_sam(modelparameter.delta,train_data);          % 整个cell返回
Y = Enhence(train_target,en_local);                             % 标记增强

Spearman_result = Statistic_Sqcorr_spearman(Y', Y);
Dcor_result = Statistic_Dcor(Y', Y);    % Dcor_result1 = Statistic_Dcor(train_data, Y);
Hoeffding_result = Statistic_Hoeffding(Y', Y);
Pearson_result = Pearson(Y', Y);
Kendall_result = Kendall(Y', Y);
Mic_result = Mic(Y', Y);
MNC_result = MNC(Y', Y);
% 将计算的相关性的结果保存到本地---前六个
Plot_data = {Spearman_result, Dcor_result, Hoeffding_result, Pearson_result, Kendall_result, Mic_result};
savepath = ['G:\研究生研究内容\Work3\临时数据存放\', dataname, '_Labels_Cor_results.mat'];
save(savepath, "Plot_data");
% 单MNC保存并绘制图形
savepath = ['G:\研究生研究内容\Work3\临时数据存放\', dataname, '_Labels_Cor_results_MNC.mat'];
save(savepath, 'MNC_result');
figure()
set(gcf,'position',[662,50,1242,942]);
heatmap(MNC_result,'Title','MNC');

% 在main.mlx文件中发现,不标准化数据的标记增强效果会更好
