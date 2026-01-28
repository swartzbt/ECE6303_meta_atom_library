function [texture, profile] = anticross(n_substrate, n_pillar, n_background, height, major_width, minor_width, varargin)
    %CROSS Generate texture and profile for anticross-shaped pillars or holes
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
    
    if num_steps == 1
        texture{2} = {n_background,...
                       [0,0,major_width,major_width,n_feature,1],...
                       [0,0,major_width,minor_width,n_background,1],...
                       [0,0,minor_width,major_width,n_background,1]};
    else
        c = (major_width + minor_width)/4;
        d = (major_width - minor_width)/2;
        texture{2} = {n_background,...
                       [c,c,d,d,n_feature,num_steps],...
                       [-c,c,d,d,n_feature,num_steps],...
                       [c,-c,d,d,n_feature,num_steps],...
                       [-c,-c,d,d,n_feature,num_steps]};
    end

    profile = {[0,height,0],[1,2,3]};
end

