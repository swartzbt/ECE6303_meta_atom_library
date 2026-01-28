function n = get_refractiveindex(yml_address, wavelength)
%get_refractiveindex Gets refractive index data from refractiveindex.info.

options = weboptions("ContentType", "table");

try
    data = webread(yml_address, options);
catch e  % File wasn't found, check if there was redirect attempt
    uri = matlab.net.URI(yml_address);
    request = matlab.net.http.RequestMessage;
    response = request.send(uri);
    if response.StatusCode == 302
        location = response.getFields("Location").Value;
        yml_address = 'https://' + uri.Host + '/' + location;
        data = webread(yml_address, options);
    else
        rethrow(e)
    end
end
data = table2array(data);

wl_raw = data(:, 1);
n_raw = data(:, 2);

% If data contains both n and k, they will be separated by a NaN row.
nan_check = isnan(wl_raw);
if any(nan_check)
    split_row = find(nan_check);    % Split data into n and k vectors
    wl_1 = wl_raw(1:split_row-1);
    wl_2 = wl_raw(split_row+1:end);
    n = n_raw(1:split_row-1);
    k = n_raw(split_row+1:end);

    out_of_bounds_check(wl_1, wavelength, yml_address, 'n')
    out_of_bounds_check(wl_2, wavelength, yml_address, 'k')

    n = interp1(wl_1, n, wavelength); % Interpolate n and k at query points
    k = interp1(wl_2, k, wavelength);

    n = n + 1i * k;  % Return complex index
    return
end

% If there is no NaN row, the data only contains real part of n.
out_of_bounds_check(wl_raw, wavelength, yml_address, 'n')
n = interp1(wl_raw, n_raw, wavelength);
return

end


function out_of_bounds_check(wl_data, wl_query, yml_address, v)
    if max(wl_query) > max(wl_data)
        warning("Requesting out-of-bounds data from %s.\n" + ...
            "File contains data for %c between %g and %g um, but you requested data for %g um.", yml_address, v, min(wl_data), max(wl_data), max(wl_query))
    end
    if min(wl_query) < min(wl_data)
        warning("Requesting out-of-bounds data from %s.\n" + ...
            "File contains data for %c between %g and %g um, but you requested data for %g um.", yml_address, v, min(wl_data), max(wl_data), min(wl_query))
    end
end
