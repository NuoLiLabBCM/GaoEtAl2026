function func_plot_bar_with_scatter(data,C,std_flg)
% data is n x m matrix, n is observation, m is condition
% c is the m x 3 matrix, indicating color of each bar
x = mean(data,1,'omitnan');
switch std_flg
    case 'std'
x_std = std(data,[],1,'omitnan');
    case 'sme'
x_std = std(data,[],1,'omitnan') ./ sqrt(size(data,1));
end

hold on
for i = 1:size(x,2)
    bar(i, x(i), 'FaceColor', C(i,:), 'EdgeColor','none', 'BarWidth',0.8);
end

errorbar(x,x_std,'Color','k','LineWidth',2,'LineStyle','none')

plot(data','Marker','o','Color','k','LineWidth',0.2)
% swarmchart(ones(size(data,1),1) *[1:size(data,2)],data,10,'filled','AlphaData',0.5,'MarkerFaceColor',[0.2 0.2 0.2],'MarkerEdgeColor',[0.2 0.2 0.2])
xticks(1:size(data,2))
end