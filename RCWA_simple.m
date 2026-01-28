function [transmitted, reflected] = RCWA_simple(wavelength, texture, profile, varargin)
%Calculate complex amplitude of normally incident transmitted light through square array of pillars
% --- INPUTS ---
% --- All geometric inputs are normalized by wavelength ---
% wavelength       - wavelength of incident light

% --- OUTPUTS ---
% transmitted       - Complex relative amplitude of 0 order transmitted TE
                      % light for incident TE light on bottom of substrate

%% parse optional input parameters

% defaults
plot_textures = false;
plot_fields = false;
delta = 90;
theta = 0;
fourier_modes = [6, 6];
period = [1, 1];
i = 1;
while i < numel(varargin)
    switch varargin{i}
        case 'plot_textures'
            plot_textures = true;
            i = i+1;
        case 'plot_fields'
            plot_fields = true;
            i = i+1;
        case 'delta'
            delta = varargin{i+1};
            i = i+2;
        case 'theta'
            theta = varargin{i+1};
            i = i+2;
        case 'fourier_modes'
            fourier_modes = varargin{i+1};
            i = i+2;
        case 'period'
            period = varargin{i+1};
            if isscalar(period)
                period = [period, period];
            end
            i = i+2;
        otherwise
            error("Unsupported parameter: %s\nin field %d", varargin{i}, i+2);
    end
end


%% Define Parameters and Textures

parm = res0;    %loads the default parameters

parm.sym.x = 0;     %x-direction mirror symmetry plane
parm.sym.y = 0;     %y-direction mirror symmetry plane
parm.sym.pol = 1;   %polarization, TE = 1, TM = -1

retio({},inf*1i);
if plot_textures
    parm.res1.trace = 1; %Sets option to plot textures when running res1
end
if plot_fields
    parm.res1.champ = 1; %Improves calculation of EM fields
end

%% Define Profile and Run RCWA solver

k_par = sind(theta);

aa = res1(wavelength, period, texture, fourier_modes, k_par, delta, parm);
result = res2(aa,profile);
transmitted = result.TEinc_bottom_transmitted.amplitude_TE{0};
reflected = result.TEinc_bottom_reflected.amplitude_TE{0};
