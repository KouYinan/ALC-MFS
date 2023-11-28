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