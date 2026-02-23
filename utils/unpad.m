%this function will recover the zeropaded matrix into origial one
%---------------------------------------------------------------------------
function output = unpad(input, N)
    [n_row, n_col] = size(input);

    begin_row = floor((n_row + mod(N,2) - N) / 2) + 1;
    end_row = begin_row + N - 1;

    begin_col = floor((n_col + mod(N,2) - N) / 2) + 1;
    end_col = begin_col + N - 1;

    output = input(begin_row:end_row, begin_col:end_col);
end