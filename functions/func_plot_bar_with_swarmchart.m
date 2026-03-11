function func_plot_bar_with_swarmchart(data,C)
% data is n x m matrix, n is observation, m is condition
% c is the m x 3 matrix, indicating color of each bar
x = mean(data,1,'omitnan');
x_sme = std(data,[],1,'omitnan');

hold on
for i = 1:size(x,2)
    bar(i, x(i), 'FaceColor', C(i,:), 'EdgeColor','none', 'BarWidth',0.8);
end

errorbar(x,x_sme,'Color','k','LineWidth',1,'LineStyle','none')
swarmchart(ones(size(data,1),1) *[1:size(data,2)],data,10,'filled','AlphaData',0.5,'MarkerFaceColor',[0.2 0.2 0.2],'MarkerEdgeColor',[0.2 0.2 0.2])
xticks(1:size(data,2))
end