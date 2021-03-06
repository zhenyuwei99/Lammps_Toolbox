function [varargout] = LammpsDataNeighborList(varargin)

%% Description
%
% *Command*:
%
% neighbor_list = LammpsDataNeighborList(data,r_cut)
%
% *Input* :
%
% data: structure created by LammpsDataReadDump(dump_name,dump_prop,dump_col,t_sim)
% r_cut: cutoff radius for neighbor list constrution

%% Calculating scaled coordinates

coord_scl               =   LammpsDataCoord2Scl(varargin{1});

%% Constructing Neighbor List

num_tolerance           =   30;
num_neighbor_max        =   round((4*pi*varargin{2}^3 /3)/(varargin{1}.box_volume) * varargin{1}.num_atoms) + num_tolerance;
neighbor_list           =   zeros(varargin{1}.num_atoms,num_neighbor_max,varargin{1}.num_steps_sim);
neighbor_list_dist    	=   zeros(varargin{1}.num_atoms,num_neighbor_max,varargin{1}.num_steps_sim);
num_neighbor            =   zeros(varargin{1}.num_atoms,varargin{1}.num_steps_sim);

for atom_01 = 1 : varargin{1}.num_atoms - 1
    for atom_02 =  atom_01 + 1 : varargin{1}.num_atoms
        r_scl = squeeze(coord_scl(atom_02,:,:))  - squeeze(coord_scl(atom_01,:,:));
        r_scl = r_scl - round(r_scl);
        r_diff = sqrt(varargin{1}.box_size' .^2 * r_scl.^2);
    	pos = find(r_diff <= varargin{2});
        num_neighbor(atom_01,pos) = num_neighbor(atom_01,pos) + 1;
        num_neighbor(atom_02,pos) = num_neighbor(atom_02,pos) + 1;
        for i = 1 : length(pos) 
            neighbor_list(atom_01,num_neighbor(atom_01,pos(i)),pos(i)) = atom_02;
            neighbor_list(atom_02,num_neighbor(atom_02,pos(i)),pos(i)) = atom_01;
            neighbor_list_dist(atom_01,num_neighbor(atom_01,pos(i)),pos(i)) = r_diff(pos(i));
            neighbor_list_dist(atom_02,num_neighbor(atom_02,pos(i)),pos(i)) = r_diff(pos(i));
        end
    end
end

%% -----------------------Output-----------------------

varargout{1}.neighbor_list      =   neighbor_list;
varargout{1}.neighbor_list_dist =   neighbor_list_dist;
varargout{1}.neighbor_num       =   num_neighbor;
