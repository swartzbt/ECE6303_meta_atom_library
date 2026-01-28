function [texture, profile] = rectangle_(n_substrate, n_pillar, n_background, height, width_x, width_y, varargin)
    %RECTANGLE Generate texture and profile for rectangular or elliptical pillars or holes
    %   By default, outputs for rectangular pillars.
    %   To output circles instead of squares, add optional argument 'round'
    %   To output holes instead of pillars, add optional argument 'holes'

    [num_steps, holes] = parse_varargin(varargin);

    texture = cell(1,3);
    texture{1} = n_background;
    texture{3} = n_substrate;

    if holes
        n_feature = n_background;
        n_background = n_pillar;
    else
        n_feature = n_pillar;
    end
    
    texture{2} = {n_background, [0, 0, width_x, width_y, n_feature, num_steps]};

    profile = {[0,height,0],[1,2,3]};
end

