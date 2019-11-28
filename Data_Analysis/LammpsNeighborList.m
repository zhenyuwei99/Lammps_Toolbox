function [varargout] = LammpsNeighborList(varargin)

%% Description
%
% *Command*:
%
% neighbor_list = LammpsNeighborList(data,r_cut)
%
% *Input* :
%
% data: structure created by LammpsReadDump(dump_name,dump_prop,dump_col,t_sim)
% r_cut: cutoff radius for neighbor list constrution

%% Calculating scaled coordinates

coord_scl               =   LammpsSclCoord(varargin{1});

%% Constructing Neighbor List

neighbor_list           =   zeros(varargin{1}.num_atoms,varargin{1}.num_atoms,varargin{1}.num_steps_sim);
neighbor_num            =   zeros(varargin{1}.num_atoms,varargin{1}.num_steps_sim);

for atom_01 = 1 : varargin{1}.num_atoms - 1
    for atom_02 =  atom_01 + 1 : varargin{1}.num_atoms
        r_scl = squeeze(coord_scl(atom_02,:,:))  - squeeze(coord_scl(atom_01,:,:));
        r_scl = r_scl - round(r_scl);
        r_diff = sqrt(varargin{1}.box_size' .^2 * r_scl.^2);
    	pos = find(r_diff <= varargin{2});
        neighbor_num(atom_01,pos) = neighbor_num(atom_01,pos) + 1;
        neighbor_num(atom_02,pos) = neighbor_num(atom_02,pos) + 1;
        for i = 1 : length(pos) 
            neighbor_list(atom_01,neighbor_num(atom_01,pos(i)),pos(i)) = atom_02;
            neighbor_list(atom_02,neighbor_num(atom_02,pos(i)),pos(i)) = atom_01;
        end
    end
end

%% -----------------------Output-----------------------

varargout{1}.neighbor_list      =   neighbor_list;
varargout{1}.neighbor_num       =   neighbor_num;
