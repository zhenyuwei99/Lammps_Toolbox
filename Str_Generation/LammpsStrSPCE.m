function [varargout] = LammpsStrSPCE(varargin)
%% Description
% function [varargout] = LammpsStrSPCE(data_cell)
%
% Input:
%
% data_cell     :   coordinate of cell points, created by function
%                   LammpsStrCellCoord
%
% Cell_Vector:
%
% 3.2660   	0           0
% 0         2.8868    	0
% 0         0           3.1729

%% Reading Input

data_cell           =   varargin{1};

%% Struture data
data_constant       =   LammpsDataConstants;
density             =   1 / data_constant.cm2an^3;                  % g/A^3
angle               =   109.47;
angle               =   angle / 180 * pi;   % Convert int to rad
bond_length         =   1.0;             % Unit: Anstrom. https://en.wikipedia.org/wiki/Water_model for more details

atom_type           =   [1,2,1];   
atom_charge         =   [0.4238,-0.8476,0.4238];      % H: 0.41.   O: -0.82. Unit: e. Write the same time as # of cell, so should be coresponds to the # of atoms in cell;
atom_mass           =   [1.00784, 15.9994];    	% H: 1.00784. O: 15.999. Unit: g/mol Only Writ once, don't need to be correspond to each atom in str_mtr;
atom_name           =   ["H","O"];

lattice_ratio       =   [4,5];
str_mtr             =   [
    0 0 0                                           %            O (0.5,0.5,0)
    1/lattice_ratio(1) 1/lattice_ratio(2) 0         %           / \
    2/lattice_ratio(1) 0 0                          %  (0,0,0) H   H (1,0.5,0)
    ];              % Normalized vectors of atom coordinate in cell

cell_vector         =   [
                        lattice_ratio(1)*bond_length*sin(angle/2)
                        lattice_ratio(2)*bond_length*cos(angle/2)
                        ( (atom_mass(1)*2 + atom_mass(2)) * data_constant.gm2g ) / (density * lattice_ratio(1)*bond_length*sin(angle/2) * lattice_ratio(2)*bond_length*cos(angle/2))
                        ];
                    
cell_vector         =   diag(cell_vector);  % Vectors that determining cell size

%% Parameters setting

% Unit: Kcal/mol
para.pair_coeff     =   [0      0
                         0.1553	3.1660];
para.bond_coeff     =   [450 bond_length];
para.angle_coeff    =   [55 angle];

%% Setting Variables

num_cell_tot        =   data_cell.num_cells;
num_cell_atoms      =   size(str_mtr,1);
num_atom_types      =   2;
num_bond_types      =   1;
num_atoms           =   num_cell_tot*num_cell_atoms;

atom_style          =   'full';

fprintf("# of atoms: %d\n",num_atoms)

%% Writing Atoms Files

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

%% Writing Bonds Files

% each elements in structure data_bond is corresponed to elements in bonds
% parts of data file in each lines.

bond_id = 0;
for cell_now = 1 : data_cell.num_cells
    bond_id = bond_id + 1;
    id_now = (cell_now - 1) * num_cell_atoms + 2; % Id of oxygen atom in each cell;
  	data_bond(bond_id,1) = bond_id;
    data_bond(bond_id,2) = 1;
    data_bond(bond_id,3:4) = [id_now,id_now-1];
    bond_id = bond_id + 1;
    data_bond(bond_id,1) = bond_id;
    data_bond(bond_id,2) = 1;
    data_bond(bond_id,3:4) = [id_now,id_now+1];
end
        
num_bonds       =   bond_id;
num_bond_types  =   1;

%% Writing Angles Files

% each elements in structure data_angle is corresponed to elements in angles
% parts of data file in each lines.

for cell_now = 1 : data_cell.num_cells
    data_angle(cell_now,1) = cell_now;
    data_angle(cell_now,2) = 1;
    id_now = (cell_now-1) * num_cell_atoms + 1;
    data_angle(cell_now,3:5) = [id_now,id_now+1,id_now+2];
end

num_angles      =   data_cell.num_cells;
num_angle_types =   1;

%% ---------------------Output-----------------------------
% Box Info
varargout{1}.box_size       =   box_size;
varargout{1}.box_tilt       =   box_tilt;
% Cell Info
varargout{1}.data_cell      =   data_cell;
varargout{1}.cell_vector    =   cell_vector;
% Para Info
varargout{1}.para           =   para;
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
% Angle Info
varargout{1}.data_angle     =   data_angle;
varargout{1}.num_angles     =   num_angles;
varargout{1}.num_angle_types=   num_angle_types;
