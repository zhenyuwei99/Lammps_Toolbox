function [coord_corr] = LammpsPBC(data)

%% Discription
% Command:
% [coord_corr] = LammpsPBC(data)
%
% Input:
% data: structure created by LammpsReadDump(dump_name,t_sim,dump_prop,dump_col)
%
% Output:
% coord_corr: corrected (or unwarpped) coordinates matric

%% Variable setting

size_coord              =   size(data.coord);

%% Handling PBC issues

coord_scl               =   zeros(size_coord);                      % scaled coordinate
coord_scl_corr          =   zeros(size_coord);                      % difference of scaled coordinate between each dump step
coord_corr              =   zeros(size_coord);                      % Corrected coordinates

for step = 1 : data.num_steps_sim
    coord_scl(:,:,step) = data.coord(:,:,step) / data.box_diag;
end

coord_corr(:,:,1)       =   data.coord(:,:,1);                      % Initial setting of corrected coordinates
coord_scl_corr(:,:,1)   =   coord_scl(:,:,1);

coord_scl_diff          =   coord_scl(:,:,2:data.num_steps_sim) - coord_scl(:,:,1:data.num_steps_sim-1);
coord_scl_diff          =   coord_scl_diff - round(coord_scl_diff);

for step = 2 : data.num_steps_sim
    coord_scl_corr(:,:,step) = coord_scl_corr(:,:,step-1) + coord_scl_diff(:,:,step-1);
    coord_corr(:,:,step)     = coord_scl_corr(:,:,step) * data.box_diag;
end

