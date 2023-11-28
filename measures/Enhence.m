function result = Enhence(train_target,C)
%   train_target: 原始数据的标记信息 value：-1 and +1;
%   C 存放的局部样本，根据局部样本对标记数据进行增强转换

result = [];
train_target = train_target';
train_target(find(train_target==-1))=0;
parfor i = 1:length(C)
    ins_indexs = C{i,1};
    ins_label = train_target(ins_indexs,:);

    % 注意这个循环的i也是每个局部样本中增强的内容的选择
    denominator = sum(ins_label(:));                    % 分母的结果
    att_ins_label = train_target(i,:);                  % 对哪个样本的标记进行增强
    if all(att_ins_label==0)                            % 判断要增强的样本的标记空间是否都为空,如果空,那么增强的结果还都是0
        enhence_result = att_ins_label;
        result = vertcat(result,enhence_result);
        continue
    else                                                % 当要增强的样本的标记空间不全为空时,对非0的标记进行增强
        enhen_index = find(att_ins_label==1);
        fenzi = sum(ins_label,1);
        enhence_r = fenzi./denominator;
        enhence_result = zeros(1,size(train_target,2));
        for j = enhen_index
            enhence_result(j) = enhence_r(j);
        end
%         enhence_r(enhence_r>0) = 1;
%         inter_two = intersect(att_ins_label, enhence_r);
    end

    % 添加判断---1.是否求和等于1
    if sum(enhence_result) ~= 1
        enhence_result = enhence_result./sum(enhence_result);
    end
    % 判断2---原始值=0，则增强后依旧=0

    %result = [result enhence_result];
    result = vertcat(result,enhence_result);
end
result = result';
end