%this function will zeropad the matrix to certain number N
%--------------------------------------------------------------------------
function [output] = zeropad(input, N)
    [n_row, n_col] = size(input);
    
    pre_row = floor((N + mod(n_row, 2) - n_row) / 2);
    pre_col = floor((N + mod(n_col, 2) - n_col) / 2);

    post_row = ((N + mod(N, 2) - n_row) / 2);
    post_col = ((N + mod(N, 2) - n_col) / 2);

    output = padarray(input, [pre_row, pre_col], 0, 'pre');
    output = padarray(output, [post_row, post_col], 0, 'post');
end