function [texture, profile] = square(n_substrate, n_pillar, n_background, height, width, varargin)
    %SQUARE Generate texture and profile for square or circular pillars or holes
    %   By default, outputs for square pillars.
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
    
    texture{2} = {n_background, [0, 0, width, width, n_feature, num_steps]};

    profile = {[0,height,0],[1,2,3]};
end

