function [train_data, test_data] = Stand(train_data,test_data)
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明

[train_data1, settings]=mapminmax(train_data', 0,1);
test_data1 = mapminmax('apply',test_data',settings);
train_data = train_data1';
test_data = test_data1';

% [train_data, settings]=mapminmax(train_data);
% test_data = mapminmax('apply',test_data,settings);
% train_data=train_data;
% test_data=test_data;
end

