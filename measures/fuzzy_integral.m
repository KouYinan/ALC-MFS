function fuzzy_corr_global = fuzzy_integral(Dcor_result1)
%%
% 
% $$max_{1\leq k \leq d} \{min(w(f'_k, l_i), W(A_k, l_j)) \}$$
% where $W(A_k,l_j) = sum_{f'\in A_k}(w(f', l_j))$ 
% where $A_k = {f'_k, f'_{k+1}, \cdots, f'_d}$ 
% 
fuzzy_corr_global = eye(size(Dcor_result1,2),size(Dcor_result1,2));
corr = Dcor_result1;
corr = sort(corr);

for i = 1:size(corr,2)
    for j = 1:size(corr,2)
        ava = [];
        for k = 1:size(corr,1)
            Ak = corr(k:end,:);
            ava = [ava min(corr(k,i), sum(Ak(:,j)))];
        end
        fuzzy_corr_global(i,j) = max(ava);
    end
end