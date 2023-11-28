% 绘制dataname_Labels_Cor_results.mat的图像(单图)
% 手动导入数据到工作区
Plot_titles = {'Spearman','Dcor','Hoeffding','Pearson','Kendall','Mic'};
figure(1);
set(gcf,'position',[662,50,1242,942]);
heatmap(Plot_data{1},'Title',Plot_titles{1});
figure(2);
set(gcf,'position',[662,50,1242,942]);
heatmap(Plot_data{2},'Title',Plot_titles{2});
figure(3);
set(gcf,'position',[662,50,1242,942]);
heatmap(Plot_data{3},'Title',Plot_titles{3});
figure(4);
set(gcf,'position',[662,50,1242,942]);
heatmap(Plot_data{4},'Title',Plot_titles{4});
figure(5);
set(gcf,'position',[662,50,1242,942]);
heatmap(Plot_data{5},'Title',Plot_titles{5});
figure(6);
set(gcf,'position',[662,50,1242,942]);
heatmap(Plot_data{6},'Title',Plot_titles{6});
% defit : 788,50,1116,942
% Bird : 662,50,1242,942