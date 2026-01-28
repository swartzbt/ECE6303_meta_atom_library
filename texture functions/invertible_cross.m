function [texture, profile] = invertible_cross(n_substrate, n_pillar, n_background, height, major_width, minor_width, varargin)
    %SQUARE Generate texture and profile for cross-shaped pillars or holes
    %   To output elliptical crosses, add optional argument 'round'
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
    
    if major_width >= minor_width
        texture{2} = {n_background,...
                       [0,0, major_width, minor_width, n_feature, num_steps],...
                       [0,0, minor_width, major_width, n_feature, num_steps]};
    elseif num_steps == 1
        texture{2} = {n_background,...
                      [0, 0, minor_width, minor_width, n_feature, 1],...
                      [0, 0, major_width, minor_width, n_background, 1],...
                      [0, 0, minor_width, major_width, n_background, 1],...
                      [0, 0, major_width, major_width, n_feature, 1]};
    else
        lobe_w = (minor_width - major_width) / 2;
        lobe_c = (minor_width + major_width) / 4;
        texture{2} = {n_background,...
                      [0, 0, major_width, major_width, n_feature, num_steps],...
                      [lobe_c, lobe_c, lobe_w, lobe_w, n_feature, num_steps],...
                      [-lobe_c, lobe_c, lobe_w, lobe_w, n_feature, num_steps],...
                      [lobe_c, -lobe_c, lobe_w, lobe_w, n_feature, num_steps],...
                      [-lobe_c, -lobe_c, lobe_w, lobe_w, n_feature, num_steps]};
    end

    profile = {[0,height,0],[1,2,3]};
end

