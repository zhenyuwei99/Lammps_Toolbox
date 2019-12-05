function [varargout] = LammpsStrBCC(varargin)
%% Description
% function [varargout] = LammpsStrBCC(num_cell,lattice_const,atom_type,atom_charge)
%
% Input:
%
% num_cell      :   3*1 vector. Each elements represents # of cells in this direction
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

str_mtr             =   [
                        0 0 0
                        1 1 1
                        ];

%% Reading Input

num_cell_tot        =   varargin{1}(1).num_cells;
[num_cell_atoms,num_dims]       =   size(str_mtr);

if varargin{3} == 1
    varargin{3} = ones(num_cell_atoms,1);
    num_atom_type = 1;
elseif varargin{3} == 2;
    varargin{3} = 1:num_cell_atoms;
    num_atom_type = num_cell_atoms;
else
    num_atom_type = length(varargin{3});
end

if varargin{4} == 0
    varargin{4} = zeros(num_cell_atoms,1);
elseif length(varargin{4}) == 1
    varargin{4} = ones(num_cell_atoms,1) * varargin{4};
end

atom_style      =   'full';

fprintf("# of atoms: %d\n",num_cell_tot*num_cell_atoms)

%% Writing Data File

box_size        =   varargin{1}.box_size .* varargin{2};

for cell_now = 1 : varargin{1}.num_cells
  	for atom = 1 : num_cell_atoms
        data_str(cell_now,atom,1) = (cell_now - 1) * num_cell_atoms + atom;
        data_str(cell_now,atom,2) = cell_now;
        data_str(cell_now,atom,3) = varargin{3}(atom);
      	data_str(cell_now,atom,4) = varargin{4}(atom);
      	data_str(cell_now,atom,5:7) = varargin{1}.coord_cell(cell_now,:) * varargin{2} + 0.5 * varargin{2} * str_mtr(atom,:);
    end
end

% ---------------------Output-----------------------------
varargout{1}.box_size       =   box_size;
varargout{1}.data_str       =   data_str;
varargout{1}.num_cell_tot   =   num_cell_tot;
varargout{1}.num_cell_atom  =   num_cell_atoms;
varargout{1}.num_atom_type  =   num_atom_type;
varargout{1}.atom_style     =   atom_style;