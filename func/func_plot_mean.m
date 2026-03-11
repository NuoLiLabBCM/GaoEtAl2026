function [x_line y_line ] = func_plot_mean_and_sem(x, y, line_color)

% x -- vector (1 x m) 
% y-- matrix (n x m)  n -- observation;  m -- feature



x_line = x;
y_line = mean(y);

alpha(0.5)
plot(x_line, y_line, 'color', line_color, 'linewidth', 1,'LineStyle','--'); hold on


return


