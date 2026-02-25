function psf = radial_thru_focus_psf(wave, pitch, wavelength, numel_fft, z_min, z_max, numel_z, numel_x)
    %RADIAL_THRU_FOCUS_PSF Calculates the through-focus psf of a radially
    %symmetric exit pupil wavefront.

    % Wave should be a vector of the wave at radial sampling points,
    % starting at r=0.

    delta_z = (z_max - z_min) / (numel_z - 1);
    center = floor(numel_fft / 2) + 1;
    unpad_start = center-numel_x+1;

    
    % Get a matrix that will apply an Abel transform on wave
    abel_mat_ms = abel_transform_mat(length(wave));
    
    % Apply the abel transform
    ms_abel = abel_mat_ms * wave;
    ms_abel = [flip(ms_abel); ms_abel(2:end-1)];  % Flip to get pos and neg side
    ms_abel = zeropad1d(ms_abel, numel_fft, 1);   % Zeropad
    
    % Get radial slice of angular spectrum via projection slice theorm
    angular_spectrum = ifftshift(fft(fftshift(ms_abel)));
    
    % Because of symmetry, I only need half of this slice
    angular_spectrum = flip(angular_spectrum(1:center));
    
    % Sampling points in k-space
    k_pitch = 2 * pi / (numel_fft * pitch);  % Space between samples in k-space, 1/μm
    kx = k_pitch * (0:numel_fft/2)';
    kx_squared = kx.^2;
    
    % How quickly the phase propagates in space at each k-space point
    phase_prop_speed = 1i * sqrt(complex((2 * pi / wavelength) ^ 2 - kx_squared));
    
    % Transfer functions
    tf_z_min = exp(z_min * phase_prop_speed);
    tf_delta_z = exp(delta_z * phase_prop_speed);
    
    % Initialize output matrix
    psf = zeros(numel_x, numel_z);
    
    % Propagate to z_min
    angular_spectrum = angular_spectrum .* tf_z_min;

    % Get first psf slice by inverse transforming using projection-slice.
    abel_mat_as = abel_transform_mat(length(angular_spectrum));
    as_abel = abel_mat_as * angular_spectrum;
    as_abel = [flip(as_abel); as_abel(2:end-1)];
    psf_i = fftshift(ifft(ifftshift(as_abel)));
    psf(:, 1) = flip(psf_i(unpad_start:center));

    % Loop through remaining z sampling points
    for i = 2:numel_z
        % Propagate to next z
        angular_spectrum = angular_spectrum .* tf_delta_z;
        
        % Inverse transform
        as_abel = abel_mat_as * angular_spectrum;
        as_abel = [flip(as_abel); as_abel(2:end-1)];
        psf_i = fftshift(ifft(ifftshift(as_abel)));
        psf(:, i) = flip(psf_i(unpad_start:center));
    end

    % Convert psf to intensity
    psf = abs(psf).^2;
end
