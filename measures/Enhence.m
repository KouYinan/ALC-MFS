function result = Enhence(train_target,C)
%   train_target value：-1 and +1;
%   C 

result = [];
train_target = train_target';
train_target(find(train_target==-1))=0;
parfor i = 1:length(C)
    ins_indexs = C{i,1};
    ins_label = train_target(ins_indexs,:);


    denominator = sum(ins_label(:));
    att_ins_label = train_target(i,:);
    if all(att_ins_label==0) 
        enhence_result = att_ins_label;
        result = vertcat(result,enhence_result);
        continue
    else                                                
        enhen_index = find(att_ins_label==1);
        fenzi = sum(ins_label,1);
        enhence_r = fenzi./denominator;
        enhence_result = zeros(1,size(train_target,2));
        for j = enhen_index
            enhence_result(j) = enhence_r(j);
        end
    end

    if sum(enhence_result) ~= 1
        enhence_result = enhence_result./sum(enhence_result);
    end

    result = vertcat(result,enhence_result);
end
result = result';
end