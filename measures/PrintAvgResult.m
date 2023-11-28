function [Avg_results, Avg_RunningTime] = PrintAvgResult(Result, runtime, cross_num)
%   Avg_results         -The mean result of evaluate, the input are number of metrics and 2,2 represents the mean and variance
    
    Avg_RunningTime = mean(runtime);
    Avg_results = zeros(5,2);
    cvResults = zeros(5, cross_num);
    for j = 1:cross_num
        cvResult(:,j) = Result{j}(:,1);
%         cvResult(:,j) = Result(:,1);
    end
    Avg_results(:,1)=mean(cvResult,2);
    Avg_results(:,2)=std(cvResult,1,2);
end