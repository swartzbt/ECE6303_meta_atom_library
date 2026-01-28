function ind = param_index(param_lim, val, varargin)
    %Calculates the index where val would be found in a vector of linearly
    %spaced values described by param_lim.
    %   param_lim -- (min_sample, max_sample, num_samples)
    %   val       -- Value to index
    
    % Optional arguments
    %   "round"   -- Rounds index to nearest integer (default no rounding)
    %   "floor"   -- Rounds index down to nearest integer
    
    round_index = 0;
    v = 1;
    while v < numel(varargin)
        switch varargin{v}
            case 'round'
                round_index = 1;
            case 'floor'
                round_index = 2;
            otherwise
                error('Unsupported parameter: %s',varargin{v});
        end
        v = v+1;
    end
    
    assert(length(param_lim) == 3, "param_lim should be a vector with " + ...
        "length 3 describing a linearly spaced array in the form " + ...
        "[min_value, max_value, number_of_values].")
    
    delta_x = (param_lim(2) - param_lim(1)) / (param_lim(3) - 1);

    ind = (val - param_lim(1)) / delta_x + 1;

    switch round_index
        case 0
        case 1
            ind = round(ind);
        case 2
            ind = floor(ind);
        otherwise
            error("round_index switch error")
    end

    

end