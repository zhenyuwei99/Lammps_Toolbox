function [varargout] = LammpsStrBCC(varargin)
%% Description
% function [varargout] = LammpsStrBCC(num_cell,lattice_const,atom_type,atom_charge)
%
% Input:
%
% data_cell     :   coordinate of cell points, created by function
%                   LammpsStrCellCoord
%
% lattice_const :   lattice constant of struture.
%
% atom_type     :   *Case 1* : atom_type = 1, all atom will be set to type 1;
%                   *Case 2* : atom_type = 2, each atom in cell will get an
%                   unique type
%                   *Case 3* : atom_type is matric. each of atom will be set
%                   to type correspond number in matric. Matric lenghth
%                   should be equal to # of atoms in cell strickly.
%
% atom_charge   :   *Case 1* : atom_charge = 0; All atom charge will be set
%                   to 0.
%                   *Case 2* : atom_charge single number. All atom will be set 
%                   to the same charge.
%                   *Case 3* : atom_charge is a matric. Each atom will be set
%                   to a charge correspond number in matric. Same as Case 3
%                   of atom_type, length of matric should be equal to
%                   number of atoms in cell

%% Struture data

lattice_const       =   varargin{2};

str_mtr             =   [
                        0 0 0
                        0.5 0.5 0.5
                        ];          % Normalized vectors of atom coordinate in cell
                    
cell_vector         =   [
                        lattice_const       0           0
                        0           lattice_const    0
                        0           0           lattice_const;
                        ];          % Vectors that determining cell size
                    
%% Reading Input
data_cell       =   varargin{1};

num_cell_tot        =   data_cell(1).num_cells;
[num_cell_atoms,num_dims]       =   size(str_mtr);
num_atoms           =   num_cell_tot*num_cell_atoms;

if varargin{3} == 1
    atom_type = ones(num_cell_atoms,1);
    num_atom_types = 1;
elseif varargin{3} == 2;
    atom_type = 1:num_cell_atoms;
    num_atom_types = num_cell_atoms;
else
    num_atom_types = length(atom_type);
end

if varargin{4} == 0
    atom_charge = zeros(num_cell_atoms,1);
elseif length(varargin{4}) == 1
    atom_charge = ones(num_cell_atoms,1) * varargin{4};
end

atom_style      =   'full';

fprintf("# of atoms: %d\n",num_atoms)

%% Writing Data File

box_size        =   data_cell.box_size .* lattice_const;

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

%% ---------------------Output-----------------------------
% Box Info
varargout{1}.box_size       =   box_size;
% Atom Info
varargout{1}.data_atom      =   data_atom;
varargout{1}.atom_style     =   atom_style;
varargout{1}.num_atoms      =   num_atoms;
varargout{1}.num_atom_types =   num_atom_types;

