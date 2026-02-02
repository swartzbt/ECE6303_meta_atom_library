function [transmitted, reflected] = RCWA_simple(wavelength, texture, profile, varargin)
%Calculate complex amplitude of normally incident transmitted light through square array of pillars
% --- INPUTS ---
% wavelength      - wavelength of incident light (scalar)
% texture         - texture cell array. See RETICOLO documentation (cell)
% profile         - profile cell array. See RETICOLO documentation (cell)
%
% --- OPTIONAL NAME-VALUE PAIRS ---
% delta           - azimuthal angle of incidence in degrees (scalar, default: 90)
% theta           - polar angle of incidence in degress (scalar, default: 0)
% fourier_modes   - number of Fourier modes in each direction (vector, default: [6, 6])
% period          - period of the array in each direction (vector, default: [1, 1])

% --- OUTPUTS ---
% transmitted       - Complex relative amplitude of 0 order transmitted TE
                      % light for incident TE light on bottom of substrate

%% parse optional input parameters
% defaults
delta = 90;
theta = 0;
fourier_modes = [6, 6];
period = [1, 1];
i = 1;
while i < numel(varargin)
    switch varargin{i}
        case 'delta'
            delta = varargin{i+1};
            i = i+2;
        case 'theta'
            theta = varargin{i+1};
            i = i+2;
        case 'fourier_modes'
            fourier_modes = varargin{i+1};
            if isscalar(fourier_modes)
                fourier_modes = [fourier_modes, fourier_modes];
            end
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

%% Run RCWA solver

k_par = sind(theta);

aa = res1(wavelength, period, texture, fourier_modes, k_par, delta, parm);
result = res2(aa,profile);
transmitted = result.TEinc_bottom_transmitted.amplitude_TE{0};
reflected = result.TEinc_bottom_reflected.amplitude_TE{0};
