clear all
clc


cell_mode = ['l l l'];
cell_num = [4 4 3];
data_cell = LammpsStrCellCoord(cell_mode,cell_num);
%data_cell = LammpsStrCutPore(data_cell,1,'z');
data = LammpsStrGenerate(data_cell,'si3n4',['x y']);

LammpsStrWrite(data,'test.data');
%{

cell_vector         =   [
                        7.595       0           0
                        3.7975      6.577463    0
                        0           0           2.902;
                        ];


for cell = 1 : 16
    for atom = 1 : 14
        id_now = (cell-1)*14 + atom;
        coord(id_now,:) = data.data_atom(cell,atom,5:7);
    end
end
r_cut = 1.9;
box_size=data.box_size;
box_diag = diag(box_size(:,2)-box_size(:,1));
coord_scl = coord / box_diag;
num_atoms=14*16;
bond_index = 1;
num_bonds = 0;
bond= zeros(num_atoms,1);

xyz =1
for x = -1 : 1
    for y = -1 : 1
        for z = -1 : 1
            neighbor_matric(xyz,:) = [x y z];
            xyz  = xyz+1;
        end
    end
end

neighbor_matric = unique(neighbor_matric * diag([1 0 1]),'row','stable');

for atom_01 = 1 : num_atoms
    id = 1;
    for atom_02 = atom_01 + 1 : num_atoms
        r_diff = (coord(atom_02,:) - coord(atom_01,:));
        r_diff = r_diff - neighbor_matric * cell_vector;
        dist = sqrt(sum(r_diff.^2,2));
        judge = dist< r_cut & dist ~=0;
        if find(judge==1)
            bond(atom_01,id) = atom_02;
            id = id+1;
            num_bonds = num_bonds+1
        end
    end
end

p_x = [-3.81 -3.81+3.7975 3.785 3.785+3.7975]
p_y = [-3.42 3.15 -3.42 3.15]

plot(p_x,p_y,'o')

data(1,:) = [2 -3.560000 -1.995000 -0.726000 ];
data(2,:) = [1 -1.944000 -1.256000 -0.726000];
data(3,:) = [2 -1.776000 0.513000 -0.726000];
data(4,:) = [2 -0.497000 -2.286000 -0.726000]; 
data(5,:) = [1 -0.492000 -3.281000 0.725000]; 
data(6,:) = [1 0.947000 -1.245000 -0.726000 ];
data(7,:) = [1 3.167000 -1.490000 0.725000];
data(8,:) = [1 -0.973000 0.963000 0.725000 ];
data(9,:) = [2 0.472000 2.005000 0.725000  ];
data(10,:) = [2 1.752000 -0.794000 0.725000] ;
data(11,:) = [ 1 1.919000 0.975000 0.725000] ;
data(12,:) = [ 2 3.535000 1.714000 0.725000 ];
data(13,:) = [1 -3.179000 1.217000 -0.726000 ];
data(14,:) = [ 1 0.466000 3.015000 -0.726000];

coord = data(:,2:4) - min(data(:,2:4))
cell_vector         =   [
                        7.595       0           0
                        3.7975      6.577463    0
                        0           0           2.902;
                        ];
                    
 norm_vec =  coord / cell_vector
%}
         
