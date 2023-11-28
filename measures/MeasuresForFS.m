
%二元变量间关联关系挖掘度量
%================1  Spearman======================
function stat = statistic_sqcorr_spearman(xs,ys)
%stat = corr(xs(:),ys(:))^2; % FUCKING THING. This requires the Matlab Statistics Toolbox
xs_rank = helper_rankorder(xs);
ys_rank = helper_rankorder(ys);
A = cov(xs_rank,ys_rank)/sqrt(var(xs_rank)*var(ys_rank)); stat = A(2,1)^2; % This doesn't.
end


function rnk = helper_rankorder(xs)
xs = xs(:);
% Sort data
[srt, idxSrt]  = sort(xs);
% Find where are the repetitions
idxRepeat = [false; diff(srt) == 0];
% Rank with tieds but w/o skipping
rnkNoSkip = cumsum(~idxRepeat);
% Preallocate rank
rnk = 1:numel(xs);
% Adjust for tieds (and skip)
rnk(idxRepeat) = rnkNoSkip(idxRepeat);
% Sort back
rnk(idxSrt)    = rnk;
rnk = rnk(:);
end


%==============2   Dcor统计量============
function stat = statistic_dcor(xs,ys)
stat = helper_distcorr(xs(:),ys(:));
end


function dcor =helper_distcorr(x,y)

% This function calculates the distance correlation between x and y.
% Reference: http://en.wikipedia.org/wiki/Distance_correlation
% Date: 18 Jan, 2013
% Author: Shen Liu (shen.liu@hotmail.com.au)

% Check if the sizes of the inputs match
if size(x,1) ~= size(y,1);
    error('Inputs must have the same number of rows')
end

% Delete rows containing unobserved values
N = any([isnan(x) isnan(y)],2);
x(N,:) = [];
y(N,:) = [];

% Calculate doubly centered distance matrices for x and y
a = pdist2(x,x,'euclidean');
mcol = mean(a);
mrow = mean(a,2);
ajbar = ones(size(mrow))*mcol;
akbar = mrow*ones(size(mcol));
abar = mean(mean(a))*ones(size(a));
A = a - ajbar - akbar + abar;

b =pdist2(y,y,'euclidean');
mcol = mean(b);
mrow = mean(b,2);
bjbar = ones(size(mrow))*mcol;
bkbar = mrow*ones(size(mcol));
bbar = mean(mean(b))*ones(size(b));
B = b - bjbar - bkbar + bbar;

% Calculate squared sample distance covariance and variances
dcov = sum(sum(A.*B))/(size(mrow,1)^2);

dvarx = sum(sum(A.*A))/(size(mrow,1)^2);
dvary = sum(sum(B.*B))/(size(mrow,1)^2);

% Calculate the distance correlation
dcor = sqrt(abs(dcov/sqrt(dvarx*dvary)));
end
%==============3   Hoeffding's D 统计量============
function stat = statistic_hoeffding(xs,ys)
stat = helper_hoeffdingsD(xs(:),ys(:));
end

function [ D ] =  helper_hoeffdingsD( x, y )

N = size(x,1);

R = helper_rankorder(x); %tiedrank( x ); % These require the Statistics Toolbox
S = helper_rankorder(y); %tiedrank( y ); % These require the Statistics Toolbox

Q = zeros(N,1);
parfor i = 1:N
    Q(i) = 1 + sum( R < R(i) & S < S(i) );
    % and deal with cases where one or both values are ties, which contribute less
    Q(i) = Q(i) + 1/4 * (sum( R == R(i) & S == S(i) ) - 1); % both indices tie.  -1 because we know point i matches
    Q(i) = Q(i) + 1/2 * sum( R == R(i) & S < S(i) ); % one index ties.
    Q(i) = Q(i) + 1/2 * sum( R < R(i) & S == S(i) ); % one index ties.
end

D1 = sum( (Q-1).*(Q-2) );
D2 = sum( (R-1).*(R-2).*(S-1).*(S-2) );
D3 = sum( (R-2).*(S-2).*(Q-1) );

D = 30*((N-2)*(N-3)*D1 + D2 - 2*(N-2)*D3) / (N*(N-1)*(N-2)*(N-3)*(N-4));
end

%==============4  Pearson 相关系数============
PearsonScore=corr(x,y,'type','Pearson');
%==============5  Kendall 相关系数============
kendall=corr(x,y,'type','Kendall' );
%==============6  mic ====需要安装========
  [mic,~]=mine(x',y');
  micResult(k)=mic.mic;

%==============7  MNC =====我的=======
 [~,MNCResult(k)] =MI_k_neighbors_Acce(x,y,'euc',0.8);
 
%======================================
% 多元变量
%==============1  MNC =====我的=======
%==============2  Dcor ============
 %==============3  HSIC =====稍后=======
 
 
