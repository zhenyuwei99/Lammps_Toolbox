function [coord] = LammpsScl2Coord(varargin)
%% Description
% 
% *Command*:
%
% coord_scl = LammpsScl2Coord(data);
%
% *Input*:
%
% data: structure created by LammpsReadDump(dump_name,dump_prop,dump_col,t_sim)

%% Calculating Coordinates from scaled Coord

coord               =   zeros(size(varargin{1}.coord));
for atom = 1 : varargin{1}.num_atoms
    coord(atom,:,:) = varargin{1}.box_diag * squeeze(varargin{1}.coord_scl(atom,:,:));
end
