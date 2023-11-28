function [cos_samples, cos_similar_result] = cos_similar_sample(cos_similar_result, threshold_cos)
% threshold_cos： cos 余弦相似度的阈值，将大于等于该值的样本重置为1，否则为0
% cos_similar_result：余弦相似度矩阵
% cos_samples: 返回的是cos相似的样本cell
% cos_similar_result: 余弦相似度0,1矩阵

cos_similar_result(cos_similar_result > threshold_cos) = 1;
cos_similar_result(cos_similar_result~=1) = 0;

cos_samples = cell(size(cos_similar_result,1), 1);          % 存放每个sample的cos相似samples

for i = 1:size(cos_similar_result,1)
    cos_samples{i,1} = find(cos_similar_result(i,:)==1);
end

end