% cell 数据转double
% 手动加载训练数据
train_data = cell2mat(bags);
train_target = targets;
% 手动加载测试数据
test_data = cell2mat(bags);
test_target = targets;