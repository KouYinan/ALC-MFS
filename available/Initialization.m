function modelparameter = Initialization
%   Model Parameters
modelparameter.delta = 0.13;                    % - The neighborhood size
modelparameter.cross_num = 5;                   % - The cross validation size
modelparameter.cv = 0;                          % - The current cross size
modelparameter.datasetname = '';                % - The dataset name, for save figure
% modelparameter.path = 'G:\KY\Project_3\figures';% - The save path

modelparameter.mu = 1e-2;                        % - The regularization parameter   -2
modelparameter.alpha = 1e-1;                     % - The regularization parameter  -3
modelparameter.lambda = 1e1;                    % - The regularization parameter    1

modelparameter.eta = 0.001;                      % - The size of learning rate

modelparameter.maxIter = 1000;                   % - The max iter times
modelparameter.err = 0.01;                      % - The max err margin

modelparameter.p = 0.25;                         % - The value of parameter p
modelparameter.Iter = 0;                        % - The actual iter times

modelparameter.K = 21;                          % - K initialization cluster size


% %   Model Results                               % - The following variables are metrics
% modelparameter.Hl_loss = [];
% modelparameter.Oe_loss = [];
% modelparameter.Rl_loss = [];
% modelparameter.CV_loss = [];
% modelparameter.AP_loss = [];        
% modelparameter.Ma_loss = [];
% modelparameter.Mi_loss = [];
% modelparameter.Sub_loss = [];
end