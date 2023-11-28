% 测试数据占全部数据的比例
testRatio = 0.3;

% 训练集索引
trainIndices = crossvalind('HoldOut', size(data, 1), testRatio);
% 测试集索引
testIndices = ~trainIndices;

target = target';

% 训练集和训练标签
train_data = data(trainIndices, :);
train_target = target(trainIndices, :);

% 测试集和测试标签
test_data = data(testIndices, :);
test_target = target(testIndices, :);

train_target = train_target';
test_target = test_target';