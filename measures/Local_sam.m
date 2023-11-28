function result = Local_sam(delta,train_data)
%   delta
%   train_data
gap = pdist(train_data,"cityblock"); 
gap = gap/size(train_data,2); 
gap = squareform(gap);
gap(find(gap<=delta))=1;

[row,col] = find(gap==1); 

row = row';col = col';

a = unique(col);
C = cell([length(a),1]);
for i = a
    e = find(col==i);
    C{i,1} = row(1:length(e));
    row(1:length(e)) = [];
end
result = C();
end