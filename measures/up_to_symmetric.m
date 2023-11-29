function symmetric_matrix = up_to_symmetric(up_matrix)
diag_eles = diag(up_matrix);
symmetric_matrix = up_matrix + diag(diag_eles)*(-1) + up_matrix';
end
