function [varargout] = LammpsStrSC(num_cell,lattice_const,atom_type,atom_charge)

% function [coord_str,size_box] = LammpsStrBCC(num_cell,lattice_const)
%
% Input:
% num_cell      :   3*1 vector. Each elements represents # of cells in this direction
% lattice_const :   lattice constant of struture.

num_cell_tot        =   num_cell(1) * num_cell(2) * num_cell(3);

str_mtr             =   [
                        0 0 0
                        ];

[num_cell_atom,num_dim]       =   size(str_mtr);

if atom_type == 0
    atom_type = ones(num_cell_atom,1);
    num_atom_type = 1;
elseif atom_type == 2;
    atom_type = 1:num_cell_atom;
    num_atom_type = num_cell_atom;
else
    num_atom_type = length(atom_type);
end

if atom_charge == 0
    atom_charge = zeros(num_cell_atom,1);
elseif length(atom_charge) == 1
    atom_charge = ones(num_cell_atom,1) * atom_charge;
end

atom_style      =   'full';

fprintf("# of atoms: %d\n",num_cell_tot*num_cell_atom)

for dim = 1 : num_dim
    size_box(dim,:) = [0 , lattice_const * num_cell(dim)];
end

for x = 1 : num_cell(1)
    for y = 1 : num_cell(2)
        for z = 1 : num_cell(3)
            cell_now = z + num_cell(3) * (y-1) + num_cell(3) * num_cell(2) * (x-1);
            for atom = 1 : num_cell_atom
                data_str(cell_now,atom,1) = (cell_now - 1) * num_cell_atom + atom;
                data_str(cell_now,atom,2) = cell_now;
                data_str(cell_now,atom,3) = atom_type(atom);
                data_str(cell_now,atom,4) = atom_charge(atom);
                data_str(cell_now,atom,5:7) = [x-1, y-1, z-1] * lattice_const + 0.5 * lattice_const * str_mtr(atom,:);
            end
        end
    end
end


% ---------------------Output-----------------------------
varargout{1}.size_box       =   size_box;
varargout{1}.data_str       =   data_str;
varargout{1}.num_cell_tot   =   num_cell_tot;
varargout{1}.num_cell_atom  =   num_cell_atom;
varargout{1}.num_atom_type  =   num_atom_type;
varargout{1}.atom_style     =   atom_style;