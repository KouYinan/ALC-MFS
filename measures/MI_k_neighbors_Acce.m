function [charaMatrix,MNC] =MI_k_neighbors_Acce(samples1,samples2,dist,alpha)
%=============
% 2018.9.23 ����������İ�������ڻ���Ϣ��ϵ����ͬ���������б��ϵ���(1/n)
% 2018.9.23  �������޸�Ϊ��Ӧ��������Ĺ���������1-1��1-�࣬��-�ࣩ
% ��������ճ���   K������Ϣ��k-���������㷨��
% �����������Ļ���Ϣ���ƣ�maximal neighborhood coefficient �������ϵ��
% input�� samples1: n*p��samples2��n*q
%output��charaMatrix :all possible multual information matrix,
% mnc: the maximal information,  shorthand  it as  mnc
%  ��������ǲ��Գƾ��󣬵��ǣ�X,Y���ͣ�Y,X����ͬ��ϻ�õ���Ϣ�����ǻ�Ϊת�õġ�
%  ���ֻ���ֻ���һ��������������Ӱ�����ֵ��
%  ���Գƾ���ӳ�������Ϣ
%=============
%  ��Ԫ example
% scatter( samples(:,1), samples(:,2));


if nargin < 3
    dist='euc';   %Ĭ�ϼ��������ŷʽ����
end
if nargin < 4
    alpha=0.8;   %�����������Χ
end

if  size(samples1,1)~= size(samples2,1)
    disp('The size of two sampels must be the same ');
end
n=size(samples1,1);
% DistX  ��samples1����������ȥ���������������������ռ�
dist_1 =pdist2(samples1,samples1,dist);
[~,index_1]=sort(dist_1,2);
% DistY    ��samples2����������ȥ���������������������ռ�
dist_2 = pdist2(samples2,samples2,dist);
[~,index_2]=sort(dist_2,2);
% ������knnsearch ����Ϊ��ͬ��Kx*Ky �󽻼���ʱ�临�Ӷȸߡ�
% �������ھ������������Ҵ�Kx*Ky �Ĳ�ͬ�����ȥ�����ֵ��Ϊ�������
tic
charaMatrix=compute_characteristic_matrix(n,alpha,index_1,index_2);
MNC=max(max(charaMatrix));
toc
end

function charaMatrix=compute_characteristic_matrix(n,alpha,index_1,index_2)
kx = 1:1:floor(n.^alpha);   % 2018.9.2 �޸������������Χ���������йض�����ʵ���ھӵ��й�
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
        %%%%%%11.8���ھ�ֵ��������%%%%%%%
        if kx_temp*ky_temp>floor((n-1).^alpha)
            charaMatrix(kx_i,ky_j)=0;
            break
        end
        %%%%%11.8���ھ�ֵ��������%%%%%%%%
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
% ���룺�������ݼ����ھӾ��� N1(n*n)  N2(n*n)
% ����������Ļ���Ϣֵ
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

