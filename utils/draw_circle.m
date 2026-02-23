function [] = draw_circle(center, radius)
    %DRAW_CIRCLE Draw a circle on the current axes
    d = 2 * radius;
    px = center(1)-radius;
    py = center(2)-radius;
    rectangle('Position',[px py d d], 'Curvature',[1,1], ...
        EdgeColor='blue', LineStyle=':');
end

