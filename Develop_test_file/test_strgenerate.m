clear all
clc

structure = 'bcc'; 
cell_mode = ['sin 2 3 5 l l']; 
cell_num = [8,10,5]; 
data_cell = LammpsStrCellCoord(cell_mode,cell_num);
lattice_const = 1;
atom_type = 1;
atom_charge = 0;
data = LammpsStrGenerate(data_cell,structure,lattice_const,atom_type,atom_charge);
