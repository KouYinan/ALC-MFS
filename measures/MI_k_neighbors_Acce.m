function [charaMatrix,MNC] =MI_k_neighbors_Acce(samples1,samples2,dist,alpha)
%=============
% 2018.9.23 第三版与第四版的区别在互信息的系数不同，理论上有保障的是(1/n)
% 2018.9.23  将程序修改为适应多种情况的关联分析（1-1，1-多，多-多）
% 整理的最终程序   K邻域互信息（k-近邻搜素算法）
% 基于邻域粒的互信息估计，maximal neighborhood coefficient 最大邻域系数
% input： samples1: n*p，samples2：n*q
%output：charaMatrix :all possible multual information matrix,
% mnc: the maximal information,  shorthand  it as  mnc
%  输出矩阵是不对称矩阵，但是（X,Y）和（Y,X）不同组合获得的信息矩阵是互为转置的。
%  因此只输出只输出一种组合情况，并不影响最大值。
%  不对称矩阵反映更多的信息
%=============
%  二元 example
% scatter( samples(:,1), samples(:,2));


if nargin < 3
    dist='euc';   %默认计算距离是欧式距离
end
if nargin < 4
    alpha=0.8;   %邻域的搜索范围
end

if  size(samples1,1)~= size(samples2,1)
    disp('The size of two sampels must be the same ');
end
n=size(samples1,1);
% DistX  从samples1的所有属性去看搜索所有样本点的邻域空间
dist_1 =pdist2(samples1,samples1,dist);
[~,index_1]=sort(dist_1,2);
% DistY    从samples2的所有属性去看搜索所有样本点的邻域空间
dist_2 = pdist2(samples2,samples2,dist);
[~,index_2]=sort(dist_2,2);
% 不采用knnsearch 是因为不同的Kx*Ky 求交集的时间复杂度高。
% 遍历了邻居组合情况，并且从Kx*Ky 的不同组合中去找最大值作为最终输出
tic
charaMatrix=compute_characteristic_matrix(n,alpha,index_1,index_2);
MNC=max(max(charaMatrix));
toc
end

function charaMatrix=compute_characteristic_matrix(n,alpha,index_1,index_2)
kx = 1:1:floor(n.^alpha);   % 2018.9.2 修改邻域的搜索范围，与样本有关而非与实际邻居点有关
nx=size(kx,2);
ky = 1:1:floor(n.^alpha);
ny=size(ky,2);
charaMatrix= zeros(size(kx,2),size(ky,2));
for kx_i=1: nx
    kx_temp= kx(kx_i);
    rodx1 = repmat((1:n)',kx_temp, 1);
    coIdx1 = index_1(:,2:kx_temp+1);
    linearIdx1 = sub2ind([n,n], rodx1, coIdx1(:));
    dist_sample1 = zeros(n,n);
    dist_sample1(linearIdx1 ) = 1;
    neigbhor1 = ones(n,1) *kx_temp;
    for ky_j=1: ny
        ky_temp= ky(ky_j);            %compute the neighbor matrix for second column
        %%%%%%11.8号邻居值重新设置%%%%%%%
        if kx_temp*ky_temp>floor((n-1).^alpha)
            charaMatrix(kx_i,ky_j)=0;
            break
        end
        %%%%%11.8号邻居值重新设置%%%%%%%%
        rodx2 = repmat((1:n)',ky_temp, 1);
        coIdx2 = index_2(:,2:ky_temp+1);
        linearIdx2 = sub2ind([n,n], rodx2, coIdx2(:));
        dist_sample2 = zeros(n,n);
        dist_sample2(linearIdx2 ) = 1;
        neigbhor2 = ones(n,1) *ky_temp;
        % compute the intersection  and multual information
        charaMatrix(kx_i,ky_j)=compute_MI( dist_sample1, neigbhor1,  dist_sample2, neigbhor2 );
    end
end
end

function  MI=compute_MI(N1,neighbor1,N2,neighbor2)
% 输入：两个数据集的邻居矩阵 N1(n*n)  N2(n*n)
% 输出：两个的互信息值
[n,~]=size(N1);
cross_matrix=N1.*N2;    % obtain common neighbor matrix
neighbor12=neighbor1.*neighbor2;
sum_cross1=sum(cross_matrix,2);    % obtian the k-1 neighbors for every object
sum_cross12=(n*sum_cross1)./neighbor12;
sum_cross12(sum_cross12==0)=[];   % remove objects without a neighbor
entropy_result = sum(log(sum_cross12));     
maxneighbor12=max(neighbor1,neighbor2);
maxneighbor12=n./maxneighbor12;
maxentropy=sum(log(maxneighbor12));
MI = entropy_result/maxentropy;
end

