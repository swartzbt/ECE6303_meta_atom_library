% clc; clearvars; close all
addpath('..\reticolo')
addpath('..\texture functions')
addpath('..\')

creator = "Brandon Swartz";

%% Materials
% Background material
mat_background = "air";
n_background = 1;
note_background = "";

% Pillar material
mat_pillar = "Si";
n_pillar = 3.427;
note_pillar = "Si at 4 um, refractiveindex.info/?shelf=main&book=Si&page=Franta-300K";

% Substrate material
mat_substrate = "Al2O3";
n_substrate = 1.675;
note_substrate = "Al2O3 at 4 um, refractiveindex.info/?shelf=main&book=Al2O3&page=Malitson-o";

%% Parameters
pitch = 2;              % μm, meta-atom pitch
height = 2.6;           % μm, meta-atom height

% Pillar Width or Diameter Sampling
num_widths = 50;       % Number of different pillar widths to simulate
min_width = 0.1 * height;  % μm, Minimum pillar width
max_width = 0.8 * pitch;   % μm, Maximum pillar width

% Wavelength Sampling
num_wavelengths = 5;  % Number of different wavelengths to simulate
min_wavelength = 3;    % μm, Minimum wavelength to simulate
max_wavelength = 5;    % μm, Maximum wavelength

pillar_shape = "circle";  % "circle" or "square"
type = "pillars";         % "pillars" or "holes"

if strcmp(pillar_shape, "square")
    corners = "square";
elseif strcmp(pillar_shape, "circle")
    corners = "round";
else
    error("Unsupported pillar shape: " + pillar_shape)
end

%%  Prepare to loop through each pillar size and each wavelength
wavelength = linspace(min_wavelength, max_wavelength, num_wavelengths);
wavelength_lim = [min_wavelength, max_wavelength, num_wavelengths];
width = linspace(min_width, max_width, num_widths);
width_lim = [min_width, max_width, num_widths];

fileStep = 100/num_widths;
overallStep = fileStep/length(height);

trans_data = zeros(num_wavelengths, num_widths, 2);

totalProgress = 0;
fileProgress = 0;
fprintf('Overall Progress: %5.2f%%\nCurrent File Progress: %5.2f%%\n', totalProgress, fileProgress);

for i = 1:length(height)
    h = height(i);
    for j1 = 1:num_widths
        width_j = width(j1);
        parfor k = 1:num_wavelengths
            [texture, profile] = square(n_substrate, n_pillar, n_background, h, width_j, corners, type);
            [trans, ~] = RCWA_simple(wavelength(k), texture, profile);
            trans_data(k,j1,:) = [real(trans) imag(trans)];
        end

        totalProgress = totalProgress + overallStep;
        fileProgress = fileProgress + fileStep;
        clc
        fprintf(['\nOverall Progress: %5.2f%%\n'...
            'Current File Progress: %5.2f%%\n'], totalProgress, fileProgress);
    end

    note = "Generated with Reticolo, last update 12/2013\n" + ...
        "using Brandon's code Generate_Square.\n";

    WriteMat(pillar_shape, "MWIR", "micron", "RealImag", ...
        "Material", mat_pillar, "pillar", n_pillar, note_pillar, ...
        "Material", mat_substrate, "substrate", n_substrate, note_substrate, ...
        "Material", mat_background, "background", n_background, note_background,...
        "Param", "wavelength", wavelength_lim, "",...
        "Param", "width", width_lim, "Width of pillar",...
        "Constant", "height", h, "",...
        "Constant", "pitch", pitch, "",...
        "Data", "transmission_bottom_0_0", trans_data, "[Real Imag] of transmitted light",...
        "Creator", creator,...
        "SaveDirectory", "..\Library Data",...
        "Notes", note)

    fileProgress = 0;
end


