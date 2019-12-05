function LammpsStrWrite(data,name_output)

desc_data   = [
    data.num_cell_tot * data.num_cell_atom
    0
    0
    0
    0
    data.num_atom_type
    0
    0
    0
    0
    ];

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


col_first = ['Lammps file creat at ',datestr(now),'\n\n'];
fprintf(fidout,col_first);

for desc = 1:num_desc
    fprintf(fidout,"%-6d\t%s\n",desc_data(desc),desc_name(desc));
end

fprintf(fidout,'%f  %f \t%s\n',data.box_size(1,1),data.box_size(1,2),'xlo xhi');
fprintf(fidout,'%f  %f \t%s\n',data.box_size(2,1),data.box_size(2,2),'ylo yhi');
fprintf(fidout,'%f  %f \t%s\n\n',data.box_size(3,1),data.box_size(3,2),'zlo zhi');
fprintf(fidout,'\n\n\nAtoms # %s\n',data.atom_style);

for cell_now = 1:data.num_cell_tot
    for atom = 1:data.num_cell_atom
        fprintf(fidout,'\n%-5d %-5d %-5d %-8.4f %-10f %-10f %-10f',...
        data.data_str(cell_now,atom,1),data.data_str(cell_now,atom,2),data.data_str(cell_now,atom,3),...
        data.data_str(cell_now,atom,4),data.data_str(cell_now,atom,5),data.data_str(cell_now,atom,6),data.data_str(cell_now,atom,7));
    end
end
