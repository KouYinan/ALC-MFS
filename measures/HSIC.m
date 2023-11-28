% https://github.com/amber0309/HSIC/blob/master/HSIC.py   Python 代码
% python implementation of Hilbert Schmidt Independence Criterion
% hsic_gam implements the HSIC test using a Gamma approximation
% 
% Gretton, A., Fukumizu, K., Teo, C. H., Song, L., Scholkopf, B., 
% & Smola, A. J. (2007). A kernel statistical test of independence. 
% In Advances in neural information processing systems (pp. 585-592).

% test: X = [train_data(:,1) train_data(:,2)]; Y = [train_data(:,3) train_data(:,4)];
% HSIC(X,Y)
function  [testState,Thresh]=HSIC(X,Y,Alph)
% Inputs:
% X 		n*p matrix  sample*dim
% Y 		n*q matrix  sample*dim
% Alph 		the significance level
% Outputs:
% HSIC	   strength of two random vectors
% Thresh   test threshold for level alpha test
% auto choose median to be the kernel width
if nargin < 3
    Alph = 0.5;   %默认显著性水平
end

n=size(X,1); % n = X.shape[0] 返回的是X的行数--i.e. samples
%  ----- width of X -----
Xmed=X; % copy to new variate Xmed
Gx=sum(Xmed.*Xmed, 2);    % G = np.sum(Xmed*Xmed, 1).reshape(n,1);% 1 表示每行相加,将矩阵压缩为一列---对应matlab的2
Qx=repmat(Gx,1,n);
Rx=repmat(Gx',n,1);

dists_x = Qx + Rx - 2*(Xmed*Xmed');
dists_x = dists_x - tril(dists_x);    % tril下三角矩阵
dists_x = reshape(dists_x, [n^2, 1]);

width_x = sqrt(0.5 * median(dists_x(dists_x>0)));

%----- width of Y -----
Ymed=Y;
Gy=sum((Ymed.*Ymed), 2);
Qy=repmat(Gy,1,n);
Ry=repmat(Gy',n,1);

dists_y = Qy + Ry - 2*(Ymed*Ymed');
dists_y=dists_y - tril(dists_y);    % tril下三角矩阵
dists_y=reshape(dists_y, [n^2,1]);

width_y = sqrt(0.5 * median(dists_y(dists_y>0)));

bone = ones(n,1);
H = eye(n) - ones(n,n)/n; % H = np.identity(n) - np.ones((n,n), dtype = float) / n; identity 是对角线矩阵
K = rbf_dot(X, X, width_x);
L = rbf_dot(Y, Y, width_y);

Kc = H*K*H; % np.dot(np.dot(H, K), H);dot 就是矩阵乘法
Lc = H*L*H;

testState = sum(Kc'*Lc,"all")/n;
varHSIC = (Kc * Lc / 6)^2;
varHSIC = (sum(varHSIC,"all") - trace(varHSIC) )/ n /(n-1);   % 这里就变成一个数了
% varHSIC = ( np.sum(varHSIC) - np.trace(varHSIC) ) / n / (n-1)
varHSIC = varHSIC * 72 * (n-4) * (n-5) / n / (n-1) / (n-2) / (n-3);

K = K - diag(diag(K));
L = L - diag(diag(L));

muX =(bone'*K*bone)/ n / (n-1); %
muY =(bone'*L*bone)/ n / (n-1);

mHSIC = (1 + muX * muY - muX - muY) / n;   %得到HSIC值

al = (mHSIC^2) / varHSIC;
bet = varHSIC*n / mHSIC;


%Thresh=gamma(1-Alph)/gamma(al/bet);   %gamma分布
%ppf = norm.ppf(1-Alph, al, bet);
% https://www.cnblogs.com/jiangkejie/p/15292260.html

%def _ppf(self, q, k, s):
%    qsk = pow(q, s*1.0/k)
%    return pow(qsk/(1.0-qsk), 1.0/s)
%qsk = (1-Alph)^(bet/al);

end

function    H = rbf_dot(pattern1,pattern2,deg) 
[p1Row,~] = size(pattern1);   % X.shape返回的是矩阵的行列数
[p2Row,~] = size(pattern2);

G = sum(pattern1.*pattern1, 2);
H = sum(pattern2.*pattern2, 2);

Q = repmat(G,1,p2Row);    % np.tile(G, (1, size2[0]));tile 是多重复制
R = repmat(H',p1Row,1);

H = Q+R-2*pattern1*pattern2';

H = exp(-H/(2*deg^2));
end



