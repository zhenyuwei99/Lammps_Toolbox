function [data] = LammpsStrGenerate(structure,num_cell,lattice_const,atom_type,atom_charge)

% function [data] = LammpsStrGenerate(structure,num_cell,lattice_const,atom_type,atom_charge)
%
% Input:
% strture       :   strture of lattice (string). SC BCC FCC DC has benn included.
% num_cell      :   3*1 vector. Each elements represents # of cells in this direction
% lattice_const :   lattice constant of struture.

if nargin <= 3
    atom_type = 0;
end

if nargin <= 4
    atom_charge = 0;
end

support_str     =   ["bcc","fcc","sc","dc"];
support_num     =   length(support_str);
support_judge   =   0;

for str = 1 : support_num
    if lower(structure) == support_str(str)
        str_id = str;
        fprintf("Structure : %s\n",structure)
        fprintf("Lattice constant: %-5.2f\n",lattice_const)
        support_judge = 1;
    end
end

if support_judge == 0
    fprintf("Error, structure is not supported !\n")
    return;
end

func = ['data = LammpsStr',upper(char(support_str(str_id))),'(num_cell,lattice_const,atom_type,atom_charge);'];
eval(func);