function [varargout] = LammpsStrSI3N4_ORT(varargin)
%% Description
% function [varargout] = LammpsStrSi3N4_ORT(data_cell,pbc,bond_arg,r_cut)
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

%% Reading Input

data_cell           =   varargin{1};
pbc                 =   varargin{2};

try 
    bond_arg    =   varargin{3}
catch
    bond_arg    =   0;
end

try
    r_cut       =   varargin{4};
catch
    r_cut       =   1.9;
end

%% Struture data

str_mtr     =   [
         0    0.5970         0
    0.0007    0.5214    0.5000
    0.0309    0.4011    0.5000
    0.0967    0.1192         0
    0.1268         0         0
    0.1276    0.9232    0.5000
    0.1469    0.3633         0
    0.1901    0.6762         0
    0.2961    0.7104    0.5000
    0.3095    0.1753         0
    0.3181    0.8449    0.5000
    0.3316    0.3098         0
    0.4373    0.3440    0.5000
    0.4824    0.6575    0.5000
    0.5000    0.0970         0
    0.5007    0.0214    0.5000
    0.5309    0.9011    0.5000
    0.5967    0.6192         0
    0.6268    0.5000         0
    0.6276    0.4232    0.5000
    0.6469    0.8633         0
    0.6901    0.1762         0
    0.7961    0.2105    0.5000
    0.8095    0.6753         0
    0.8181    0.3449    0.5000
    0.8316    0.8098         0
    0.9373    0.8440    0.5000
    0.9824    0.1575    0.5000
    ];

cell_vector         =   [
                        7.595       0           0
                        0     13.154964    0
                        0           0           2.902;
                        ]; % Vectors that determining cell size

atom_type           =   [2,1,1,2,2,2,1,2,1,1,2,1,1,1,2,1,1,2,2,2,1,2,1,1,2,1,1,1];   
atom_charge         =   1.34925 .* atom_type - 1.9275;      % Si: 0.7710.   N: -0.57825. Unit: e
atom_mass           =   [14.0067 28.085501];                % N: 14.0067. Si: 28.085501. Unit: g/mol
atom_name           =   ["N","Si"];

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
