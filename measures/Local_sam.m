function result = Local_sam(delta,train_data)
%   delta是距离阈值大小的控制
%   train_data 是输入的计算数据
gap = pdist(train_data,"cityblock");            % sum(x_si-x_ti),i=1,2,3...m
gap = gap/size(train_data,2);                                    % 结果取平均
gap = squareform(gap);                          % 重塑为原距离方阵
gap(find(gap<=delta))=1;                        % 用1来表示局部样本类，用于下一步进行数据增强

[row,col] = find(gap==1);                       % 找到了索引位置

row = row';col = col';
% 可以按行也可以按列进行整理样本类，因为距离矩阵是对称的
a = unique(col);                                % 去重
C = cell([length(a),1]);                        % 局部样本
for i = a
    e = find(col==i);
    C{i,1} = row(1:length(e));
    row(1:length(e)) = [];
end
result = C();% 整个cell返回
end