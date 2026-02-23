function mat = abel_transform_mat(n)
    %ABEL_TRANSFORM_MAT Creates a matrix that applies an approximate Abel
    % transform to a vector of length n.
    %This is not well validated. Do not use for research without doing
    % due diligence.
    
    x = 0:n-1;
    r = x.^2 + x'.^2;
    r = sqrt(r) + 1;
    
    aperture = r <= n;
    
    cols = floor(r);
    rows = repmat((1:n)', 1, n);
    
    w_2 = r - cols;
    w_1 = 1-w_2;
    
    w_1(:, 2:end) = 2 * w_1(:, 2:end);
    w_2(:, 2:end) = 2 * w_2(:, 2:end);
    
    w_1 = w_1(aperture);
    w_2 = w_2(aperture);
    
    cols = cols(aperture);
    rows = rows(aperture);
    
    include = w_2 > 1e-8;
    
    rows = [rows; rows(include)];
    cols = [cols; cols(include)+1];
    w = [w_1; w_2(include)];
    
    mat = accumarray([rows, cols], w, [n, n]);
end

