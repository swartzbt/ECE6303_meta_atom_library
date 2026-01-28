function [texture, profile] = ring(n_substrate, n_pillar, n_background, height, width_outer, width_inner, varargin)
    %RING Generate texture and profile for square or circular rings
    %   By default, outputs for square ring pillars.
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
    
    if width_inner == 0
        texture{2} = {n_background,...
                      [0, 0, width_outer, width_outer, n_feature, num_steps]};
    else
        texture{2} = {n_background,...
                      [0, 0, width_outer, width_outer, n_feature, num_steps],...
                      [0, 0, width_inner, width_inner, n_background, num_steps]};
    end

    profile = {[0,height,0],[1,2,3]};
end

