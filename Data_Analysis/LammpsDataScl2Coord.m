function [coord] = LammpsDataScl2Coord(varargin)
%% Description
% 
% *Command*:
%
% coord_scl = LammpsDataScl2Coord(data);
%
% *Input*:
%
% data: structure created by LammpsDataReadDump(dump_name,dump_prop,dump_col,t_sim)

%% Calculating Coordinates from scaled Coord

coord               =   zeros(size(varargin{1}.coord));
for atom = 1 : varargin{1}.num_atoms
    coord(atom,:,:) = varargin{1}.box_diag * squeeze(varargin{1}.coord_scl(atom,:,:));
end
