function PrintResult(Result, time)
% 将结果输出打印：
fprintf('----------------------------------------------------\n');
fprintf('HammingLoss            %.3f  %.3f\r',Result(1,1),Result(1,2));
fprintf('RankingLoss            %.3f  %.3f\r',Result(2,1),Result(2,2));
fprintf('One Error              %.3f  %.3f\r',Result(3,1),Result(3,2));
fprintf('Coverage               %.3f  %.3f\r',Result(4,1),Result(4,2));
fprintf('Average Precision      %.3f  %.3f\r',Result(5,1),Result(5,2));
fprintf('Running time           %.3f  \r',time);
fprintf('----------------------# # # Running Ending # # #------------------------\n');
end