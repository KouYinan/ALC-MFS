% Varing one parameter while keeping the other two parameters fixed.
% The results are obtained by five evaluate metrics
% iter one parameter

clear; % clc;
% Load the file, including train_data\target (NxD and LxN) and test_data\target (MxD and LxM)

dataname = 'arts.mat';
load (dataname);

para = [1e-5, 1e-4, 1e-3, 1e-2, 1e-1, 1e1, 1e2, 1e3, 1e4, 1e5];
% para = [1e-7, 1e-6, 1e-5, 1e-4, 1e-3, 1e-2, 1e-1, 1e1, 1e2, 1e3, 1e4, 1e5];
% para = [4e-5, 4e-4, 4e-3, 4e-2, 4e-1, 4e1, 4e2, 4e3, 4e4, 4e5];

% 保存命令行内容
% com_name = [dataname '_command'  '.txt'];
% diary(com_name);

% Ibitialization parameters
modelparameter =  Initialization;
modelparameter.datasetname = dataname;
runtime = zeros(1, modelparameter.cross_num);

test_target(find(test_target==-1))=0;train_target(find(train_target==-1))=0;
test_target = double(test_target);train_target = double(train_target);
data = [train_data; test_data];target = double([train_target,test_target]);
clear train_data test_data train_target test_target

[DN,~] = size(data);[~,TN] = size(target);
cross_num = modelparameter.cross_num;
indices = crossvalind('Kfold', DN, cross_num);
% cvResult  = cell(cross_num, 1);     
cv = 1;
test = (indices == cv);train = ~test;
test_data = data(test,:);test_target = target(:,test);
train_data = data(train,:);train_target = target(:,train);
[train_data, test_data] = Stand(train_data,test_data);
modelparameter.cv = cv;

% tic;
% Enhence label space
en_local = Local_sam(modelparameter.delta,train_data);
train_Y = Enhence(train_target,en_local);

% Obtain label correlation
label_corr = LabelCorr(train_data, train_Y, modelparameter);

cvResult  = cell(length(para), 1);
% Training model
for i = 1:length(para)
    modelparameter.mu = para(i);
    model = EL_train(train_data, train_Y', label_corr, modelparameter, cv);
    % Predict and Evaluate
    cvResult{i} = EL_test(test_data, test_target, model, modelparameter, train_data, train_target, cv);
    % runtime(1,cv) = toc;
    fprintf('running %d is over \n', i);
end
perfromance = cell2mat(cvResult');
disp(perfromance);
save_name = [dataname '_mu' '.txt'];
cd sear/
save(save_name, "perfromance",'-ascii');
cd ../
beep;
% diary('off');