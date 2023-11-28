% The multi-label sparse feature selection main running file

clear; % clc;
% Load the file, including train_data\target (NxD and LxN) and test_data\target (MxD and LxM)
tic
dataname = 'PlantPseAAC.mat';%Scene
load (dataname);

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
cvResult  = cell(cross_num, 1);% cite MVLD
for cv = 1:cross_num       
    test = (indices == cv);train = ~test;
    test_data = data(test,:);test_target = target(:,test);
    train_data = data(train,:);train_target = target(:,train);
    [train_data, test_data] = Stand(train_data,test_data);
    modelparameter.cv = cv;
    
    tic;
    % Enhence label space
    en_local = Local_sam(modelparameter.delta,train_data);
    train_Y = Enhence(train_target,en_local);
    
    % tic
    % Obtain label correlation
    label_corr = LabelCorr(train_data, train_Y, modelparameter);
    % Training model
    model = EL_train(train_data, train_Y', label_corr, modelparameter, cv);
    % Predict and Evaluate
    cvResult{cv} = EL_test(test_data, test_target, model, modelparameter, train_data, train_target, cv);
    runtime(1,cv) = toc;
end

[Avg_results, Avg_RunningTime] = PrintAvgResult(cvResult, runtime, cross_num);% cross_num
PrintResult(Avg_results, Avg_RunningTime);

f = figure;
% plot(model.gradient,'-o');
plot(model.gradient);
xlabel('Iteration number');
ylabel('Gradient value');
perfromance = cell2mat(cvResult');
% cd saveresults\
% save([dataname '_cvResult.mat'],"perfromance");
% save([dataname '_LabelCorr.mat'],"label_corr");
% save([dataname '_AvgResult.mat'],"Avg_results","Avg_RunningTime");
% saveas(f, [dataname '_gradient.pdf']);
% cd ..\

beep;
toc
% diary('off');
