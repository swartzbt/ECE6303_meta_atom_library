function [] = bipolar_colormap(ax)
if nargin == 0
    ax = gca;
end
clim = get(ax,'CLim');
if min(clim)>=0 || max(clim)<=0
    colormap(ax, 'hot')
else
    n = 256-1;
    n_neg = -n*clim(1)/(clim(2)-clim(1));
    n = diff(round([linspace(0,n_neg,4) linspace(n_neg,n,4)]));
    n(4) = [];
    cmap = [linspace(1,0,n(1))' ones(n(1),2);
            zeros(n(2),1) linspace(1,0,n(2))' ones(n(2),1);
            zeros(n(3),2) linspace(1,0,n(3))';
            0 0 0;
            linspace(0,1,n(4))' zeros(n(4),2);
            ones(n(5),1)  linspace(0,1,n(5))' zeros(n(5),1);
            ones(n(6),2)  linspace(0,1,n(6))'];
    colormap(ax, cmap);
end
end