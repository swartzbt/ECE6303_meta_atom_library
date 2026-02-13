function [] = format_plot(ax)
% Labels
if nargin == 0
    ax = gca; % Get current axes if no axes are provided
end

lines = get(ax, 'children');
for i = 1:size(lines,1)
    if strcmp(lines(i).Type,'line')
        set(lines(i), 'LineWidth', 1.0)
        set(lines(i), 'MarkerSize',6)
    end
end 

fig = ancestor(ax, 'figure');
set(ax, 'LineWidth', 1.0, 'FontSize', 12, 'FontWeight', 'bold');
set(get(ax, 'XLabel'), 'FontSize', 14, 'FontWeight', 'bold')
set(get(ax, 'YLabel'), 'FontSize', 14, 'FontWeight', 'bold')
set(get(ax, 'Title'), 'FontSize', 16, 'FontWeight', 'bold')
set(fig, 'Color', 'w')
end