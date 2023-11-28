
function ResultAll = EvaluationAll(Pre_Labels,Outputs,test_target)
%       Pre_labels              - The LxM array,L is the side of lables, M is the size of test samples
%       Outputs                 - The LxM array,
%       test_target             - The ture label values of testing set

    ResultAll=zeros(5,1); 

    HammingLoss = Hamming_loss(Pre_Labels',test_target);
    RankingLoss = Ranking_loss(Outputs',test_target);
    OneError = One_error(Outputs',test_target);
    Coverage = coverage(Outputs',test_target);
    Average_Precision = Average_precision(Outputs',test_target);

    ResultAll(1,1)  = HammingLoss;
    ResultAll(2,1)  = RankingLoss;
    ResultAll(3,1)  = OneError;
    ResultAll(4,1)  = Coverage;
    ResultAll(5,1)  = Average_Precision;
end