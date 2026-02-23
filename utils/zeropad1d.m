%this function will zeropad the matrix to certain number N
%--------------------------------------------------------------------------
function [output] = zeropad1d(input, N, dim)
    size_in = size(input);
    n_in = size_in(dim);
    
    pre = zeros(1, length(size_in));
    post = zeros(1, length(size_in));

    pre(dim) = floor((N + mod(n_in, 2) - n_in) / 2);
    post(dim) = ((N + mod(N, 2) - n_in) / 2);

    output = padarray(input, pre, 0, 'pre');
    output = padarray(output, post, 0, 'post');
end