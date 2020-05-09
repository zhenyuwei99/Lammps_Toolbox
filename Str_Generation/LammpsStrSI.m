function [varargout] = LammpsStrSI(varargin)
%% Description
% function [varargout] = LammpsStrSI(data_cell,pbc,bond_arg,r_cut)
%
% Input:
%
% data_cell     :   coordinate of cell points, created by function
%                   LammpsStrCellCoord
% pbc           :   Determing the boundary need to be replicaed. 
%                   Default :['x y']. Notice: No space can be left in
%                   string, like['x y ']
% bond_arg      :   arg determins whether bonds will be generated, 
%                   1: yes; 0: no. Default: not generate
% r_cut         :   cut off radius for bond recognition. Default: 1.9 A
%
% Cell_Vector:
%
% 5.4310    0           0
% 0         5.4310      0
% 0         0           5.4310
%% Reading Input

data_cell           =   varargin{1};
pbc                 =   varargin{2};

try 
    bond_arg    =   varargin{3};
catch
    bond_arg    =   0;
end

try
    r_cut       =   varargin{4};
catch
    r_cut       =   1.9;
end

%% Struture data

str_mtr             =   [
    0       0       0
    0       0.5     0.5
    0.5     0       0.5
    0.5     0.5     0
    0.25    0.25    0.25
    0.25    0.75    0.75
    0.75    0.25    0.75
    0.75    0.75    0.25
 ];

cell_vector         =   [
    5.4310   	0           0
  	0           5.4310    	0
  	0           0           5.4310
]; % Vectors that determining cell size

atom_type           =   [1;1;1;1;1;1;1;1];   
atom_charge         =   0 .* atom_type;      % Si: 0.7710.   N: -0.57825. Unit: e
atom_mass           =   [28.085501];                % N: 14.0067. Si: 28.085501. Unit: g/mol
atom_name           =   ["Si"];
%% Setting Variables

num_cell_tot        =   data_cell.num_cells;
num_cell_atoms      =   size(str_mtr,1);
num_atom_types      =   2;
num_bond_types      =   1;
num_atoms           =   num_cell_tot*num_cell_atoms;

atom_style          =   'full';

fprintf("# of atoms: %d\n",num_atoms)

%% Writing Atoms File

box_vector      =   cell_vector;
box_vector(2,1) =   0;
box_vector(3,1) =   0;
box_vector(3,2) =   0;
box_size        =   box_vector * data_cell.box_size ;

box_tilt        =   [
    cell_vector(2,1) * data_cell.num_cells_vec(2)
    cell_vector(3,1) * data_cell.num_cells_vec(3)
    cell_vector(3,2) * data_cell.num_cells_vec(3)];  % xy xz yz for box arrangement
    

for cell_now = 1 : data_cell.num_cells
  	for atom = 1 : num_cell_atoms
        id_now = (cell_now - 1) * num_cell_atoms + atom;
        data_atom(id_now,1) = (cell_now - 1) * num_cell_atoms + atom;
        data_atom(id_now,2) = cell_now;
        data_atom(id_now,3) = atom_type(atom);
      	data_atom(id_now,4) = atom_charge(atom);
      	data_atom(id_now,5:7) = data_cell.coord_cell(cell_now,:) * cell_vector  + str_mtr(atom,:) * cell_vector;
    end
end

%% Writing Bonds File

if bond_arg
    coord   =   data_atom(:,5:7);

    box_diag = diag(box_size(:,2)-box_size(:,1));

    neighbor_matric = [0 0 0;1 0 0;0 1 0;0 0 1;1 1 0; 1 0 1;0 1 1;1 1 1;
        -1 0 0;0 -1 0;0 0 -1;-1 -1 0; -1 0 -1;0 -1 -1;-1 -1 -1];
    try 
        pbc = split(pbc);
        judge = ['x';'y';'z'];
        neighbor_modify = zeros(1,3);
        for dim = 1 : length(pbc)
            pos = find(pbc{dim} == judge);
            neighbor_modify(pos) = 1;
        end
        neighbor_matric = neighbor_matric * diag(neighbor_modify);
        neighbor_matric = unique(neighbor_matric,'rows','stable');
    end

    neighbor_matric = neighbor_matric * diag(data_cell.num_cells_vec);

    num_bonds = 0;

    for atom_01 = 1 : num_atoms
        for atom_02 = atom_01+1 : num_atoms
            r_diff = (coord(atom_02,:) - coord(atom_01,:));
            r_diff = r_diff - neighbor_matric * cell_vector;
            dist = sqrt(sum(r_diff.^2,2));
            judge = dist< r_cut & dist~=0; 
            if find(judge==1) 
                num_bonds = num_bonds+1;
                data_bond(num_bonds,1) = num_bonds;
                data_bond(num_bonds,2) = 1;
                data_bond(num_bonds,3:4) = [atom_01,atom_02];
            end
        end
    end

    num_bond_types  =   1;
end

%% ---------------------Output-----------------------------
% Box Info
varargout{1}.box_size       =   box_size;
varargout{1}.box_tilt       =   box_tilt;
% Atom Info
varargout{1}.data_atom      =   data_atom;
varargout{1}.num_atoms      =   num_atoms;
varargout{1}.atom_style     =   atom_style;
varargout{1}.atom_mass      =   atom_mass;
varargout{1}.atom_name      =   atom_name;
varargout{1}.num_atom_types =   num_atom_types;
% Bond Info
try
    varargout{1}.data_bond      =   data_bond;
    varargout{1}.num_bonds      =   num_bonds;
    varargout{1}.num_bond_types =   num_bond_types;
end
