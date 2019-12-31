function [varargout] = LammpsStrSI3N4(varargin)
%% Description
% function [varargout] = LammpsStrSi3N4(data_cell,pbc,r_cut)
%
% Input:
%
% data_cell     :   coordinate of cell points, created by function
%                   LammpsStrCellCoord
% pbc           :   Determing the boundary need to be replicaed. 
%                   Default :['x y']. Notice: No space can be left in
%                   string, like['x y ']
% r_cut         :   cut off radius for bond recognition. Default: 1.9 A

%% Reading Input

data_cell           =   varargin{1};
pbc                 =   varargin{2};
try
    r_cut = varargin{3};
catch
    r_cut = 1.9;
end

%% Struture data

str_mtr             =   [
    -0.0977580565637542,0.195516113127508,0;
    0.0588368288671674,0.307869462739661,0;
    -0.0535176961032620,0.576818144016926,0;
    0.327654573699065,0.151274131074550,0;
    0.403949967083608,0,0.500000000000000;
    0.438645801493259,0.309541840068124,0;
    0.749567567747191,0.272293435934189,0.500000000000000;
    0.0180020380857845,0.645233580181295,0.500000000000000;
    0.129048914298138,0.803653323477456,0.500000000000000;
    0.510352849669919,0.378109310535080,0.500000000000000;
    0.397866659130036,0.647057991812345,0.500000000000000;
    0.554461544560957,0.759411341424498,0.500000000000000;
    -0.291760564557441,0.683850293038517,0;
    0.0514815980747357,0.957207969090818,0
    ];              % Normalized vectors of atom coordinate in cell
                    
cell_vector         =   [
                        7.595       0           0
                        3.7975      6.577463    0
                        0           0           2.902;
                        ]; % Vectors that determining cell size

atom_type           =   [2;1;1;2;1;2;1;1;2;1;2;1;1;2];   
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
varargout{1}.data_bond      =   data_bond;
varargout{1}.num_bonds      =   num_bonds;
varargout{1}.num_bond_types =   num_bond_types;
