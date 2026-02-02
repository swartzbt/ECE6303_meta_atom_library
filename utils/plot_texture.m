function plot_texture(texture, profile, period)
    parm = res0;        %loads the default parameters
    parm.sym.x = 0;     %x-direction mirror symmetry plane
    parm.sym.y = 0;     %y-direction mirror symmetry plane
    parm.sym.pol = 1;   %polarization, TE = 1, TM = -1
    
    retio({},inf*1i);
    
    sym=[0,0,0,0];
    x=linspace(-period(1)/2,period(1)/2,parm.res1.nx);
    y=linspace(-period(2)/2,period(2)/2,parm.res1.ny);
    num_texture = size(texture, 2);
    nxy=cell(num_texture, 1);

    init = retinit(period, [0, 0, 0, 0], [0, 0, 0], sym);
    
    for ii=1:num_texture
        if ~iscell(texture{ii})
            texture{ii}={texture{ii}};
        end
        u=retu(init,[texture{ii},{1,1}]);
        
        nxy{ii} = rettestobjet(init,u,-1,[],{x,y});
    end
    
    num_layers = length(profile{1});
    nxyz = zeros([length(x), length(y), 2*num_layers]);
    z = zeros(1, 2*num_layers);
    current_z = 0;
    for i = 1:num_layers
        nxyz(:,:,2*i-1:2*i) = repmat(nxy{profile{2}(i)}, 1, 1, 2);
        z(2*i-1) = current_z;
        layer_thickness = max(profile{1}(i), eps);
        current_z = current_z - layer_thickness;
        z(2*i) = current_z + eps;
    end
    z = z + sum(profile{1});
    [xx, yy, zz] = meshgrid(x,y,z);
    
    unique_vals = [];
    for i = 1:length(nxy)
        unique_vals = [unique_vals; unique(nxy{i})];
    end
    unique_vals = unique(unique_vals);
    unique_vals = sort(unique_vals(unique_vals ~= 1));

    hold on
    for n = unique_vals'
        s = isosurface(xx, yy, zz, nxyz, n-eps);
        patch(s, "EdgeColor", "none", "FaceAlpha", 0.5 * (n-1) / max(unique_vals));
    end

    view(30, 30)

    axis image
    xlabel('μm')
end