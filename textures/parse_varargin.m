function [num_steps, holes] = parse_varargin(args)
    % Parse optional input args of texture function to set parameters that
    % control whether texture is square or round and whether structure uses
    % pillars or holes.
    
    % num_steps is used to approximate rounded structures.
    % Value of 1 means corners will be square.
    num_steps = 1;

    holes = false; % bool to toggle whether to output holes or pillars

    v = 1;
    while v <= numel(args)
        switch args{v}
            case 'square'
                num_steps = 1;
            case 'round'
                num_steps = 36;
            case 'pillars'
                holes = false;
            case 'holes'
                holes = true;
            otherwise
                error('Unsupported parameter: %s',args{v});
        end
        v = v+1;
    end
end

