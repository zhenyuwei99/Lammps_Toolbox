function [coord_scl] = LammpsCoord2Scl(varargin)
%% Description
% 
% *Command*:
%
% coord_scl = LammpsCoord2Scl(data);
%
% *Input*:
%
% data: structure created by LammpsReadDump(dump_name,dump_prop,dump_col,t_sim)

%% Calculating Scaled Coord

coord_scl               =   zeros(size(varargin{1}.coord));
for atom = 1 : varargin{1}.num_atoms
    coord_scl(atom,:,:) = varargin{1}.box_diag \ squeeze(varargin{1}.coord(atom,:,:));
end
