function symmetric_matrix = up_to_symmetric(up_matrix)
% 将上三角矩阵转换为对称矩阵
%   此处提供详细说明
diag_eles = diag(up_matrix);
symmetric_matrix = up_matrix + diag(diag_eles)*(-1) + up_matrix';
end