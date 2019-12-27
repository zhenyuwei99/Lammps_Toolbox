function [varargout] = LammpsDataRDF(data_01,data_02,r_cut,num_bins)
%% Description
%
% function [varargout] = LammpsDataRDF(data_01,data_02,r_cut,num_bins) 
%
% Input:
% data_01: structure of atom_01 created by LammpsDataReadDump(dump_name,t_sim,dump_prop,dump_col)
% data_02: structure of atom_02 created by LammpsDataReadDump(dump_name,t_sim,dump_prop,dump_col)
% r_cut: cut off radius in RDF calculation
% num_bins: # of bins in RDF calculation

%% Mode selection



%% Calculating Scaled Coordinate

coord_scl_01            =   LammpsDataCoord2Scl(data_01);
coord_scl_02            =   LammpsDataCoord2Scl(data_02);

%% Variables setting

r_delta                 =   r_cut / num_bins;
rho_02                  =   data_02.num_atoms / (data_02.box_volume);

%% Calculating RDF

g_x                     =   [1:num_bins] ./ (num_bins/r_cut);
g_raw                   =   zeros(data_01.num_atoms,num_bins,data_01.num_steps_sim);
g_time_avg              =   zeros(data_01.num_atoms,num_bins);

for atom_01 = 1 : data_01.num_atoms
    for atom_02 = 1 : data_02.num_atoms
        r_scl = squeeze(coord_scl_02(atom_02,:,:) - coord_scl_01(atom_01,:,:));
        r_scl = r_scl - round(r_scl);
        r_diff = sqrt(data_01.box_size' .^2 * r_scl.^2);
        pos = intersect(find(r_diff <= r_cut),find(r_diff > 0));                % postion of time_step
        bin = ceil(r_diff ./ r_delta);
        for i = 1 : length(pos)
            g_raw(atom_01,bin(pos(i)),pos(i)) = g_raw(atom_01,bin(pos(i)),pos(i)) + 1;
        end
    end
end

for atom_01 = 1 : data_01.num_atoms
    g_time_avg(atom_01,:) = mean(squeeze(g_raw(atom_01,:,:)),2);
end

g                   =   mean(g_time_avg,1);

for bin = 1 : num_bins
    g(bin) = g(bin) / (4 * pi * (bin * r_delta)^2 * r_delta * rho_02);
end

%% -----------------------Output-----------------------
varargout{1}.g_x                =   g_x;
varargout{1}.g                  =   g;