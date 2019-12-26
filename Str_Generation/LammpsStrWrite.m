function LammpsStrWrite(data,name_output)

try
    desc_data   = [
        data.num_atoms
        data.num_bonds
        0
        0
        0
        data.num_atom_types
        data.num_bond_types
        0
        0
        0
        ];
catch
    desc_data   = [
        data.num_atoms
        0
        0
        0
        0
        data.num_atom_types
        0
        0
        0
        0
        ];
end

desc_name   = [
    "atoms"
    "bonds"
    "angles"
    "dihedrals"
    "impropers"
    "atom types"
    "bond types"
    "angle types"
    "dihedral types"
    "improper types"
    ];

num_desc = length(desc_data);

fidout = fopen(name_output, 'w');

%% File Date

col_first = ['Lammps file creat at ',datestr(now),'\n\n'];
fprintf(fidout,col_first);

%% File Information

for desc = 1:num_desc
    fprintf(fidout,"%-6d\t%s\n",desc_data(desc),desc_name(desc));
end

fprintf(fidout,'%f  %f \t%s\n',data.box_size(1,1),data.box_size(1,2),'xlo xhi');
fprintf(fidout,'%f  %f \t%s\n',data.box_size(2,1),data.box_size(2,2),'ylo yhi');
fprintf(fidout,'%f  %f \t%s\n\n',data.box_size(3,1),data.box_size(3,2),'zlo zhi');

try
    fprintf(fidout,'%f\t%f\t%f \t%s\n',data.box_iter(1),data.box_iter(2),data.box_iter(3),'xy xz yz');
end

try
    fprintf(fidout,'\n\nMasses\n\n');
    for type = 1 : data.num_atom_types
        fprintf(fidout,'%i\t%f # %s\n',type,data.atom_mass(type),data.atom_name(type));
    end
end

%% Atoms Information

fprintf(fidout,'\n\n\nAtoms # %s\n',data.atom_style);

for cell_now = 1:data.num_cell_tot
    for atom = 1:data.num_cell_atom
        fprintf(fidout,'\n%-5d %-5d %-5d %-8.4f %-10f %-10f %-10f',...
        data.data_atom(cell_now,atom,1),data.data_atom(cell_now,atom,2),data.data_atom(cell_now,atom,3),...
        data.data_atom(cell_now,atom,4),data.data_atom(cell_now,atom,5),data.data_atom(cell_now,atom,6),data.data_atom(cell_now,atom,7));
    end
end

%% Bonds Information

try 
    data.data_bond;
    flag = 1;
catch
    flag = 0;
end

if flag == 1
    id_now = 1;
    fprintf(fidout,'\n\nBonds\n\n');
    for atom_01 = 1 : data.data_bond.num_atoms
        for atom_02 = 1 : data.data_bond.num_bonds(atom_01)
            fprintf(fidout,'%i\t%i\t%i\t%i\n',id_now,1,atom_01,data.data_bond.id(atom_01,atom_02));
            id_now = id_now + 1;
        end
    end
end

