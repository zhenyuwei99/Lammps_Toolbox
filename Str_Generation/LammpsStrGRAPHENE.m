function [varargout] = LammpsStrGRAPHENE(varargin)
%% Description
% function [varargout] = LammpsStrSi3N4(data_cell,pbc,r_cut)
%
% Input:
%
% data_cell     :   coordinate of cell points
% r_cut         :   cut off radius for bond recognition. Default: 1.9 A
% pbc           :   Determing the boundary need to be replicaed. 
%                   Default :['x y']. Notice: No space can be left in
%                   string, like['x y ']

%% Struture data

str_mtr             =   [
    0   0   0
    
    ];
                    
cell_vector         =   [
                        1	0   0
                        0   1   0
                        0	0   1
                        ];

atom_type           =   [2;1;1;2;1;2;1;1;2;1;2;1;1;2];   
atom_charge         =   1.34925 .* atom_type - 1.9275;      % Si: 0.7710.   N: -0.57825. Unit: e
atom_mass           =   [14.0067 28.085501];                % N: 14.0067. Si: 28.085501. Unit: g/mol
atom_name           =   ["N","Si"];
%% Setting Variables

num_cell_tot        =   varargin{1}.num_cells;
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
box_size        =   box_vector * varargin{1}.box_size ;

box_iter        =   [
    cell_vector(2,1) * varargin{1}.num_cells_vec(2)
    cell_vector(3,1) * varargin{1}.num_cells_vec(3)
    cell_vector(3,2) * varargin{1}.num_cells_vec(3)];  % xy xz yz for box arrangement
    

for cell_now = 1 : varargin{1}.num_cells
  	for atom = 1 : num_cell_atoms
        data_atom(cell_now,atom,1) = (cell_now - 1) * num_cell_atoms + atom;
        data_atom(cell_now,atom,2) = cell_now;
        data_atom(cell_now,atom,3) = atom_type(atom);
      	data_atom(cell_now,atom,4) = atom_charge(atom);
      	data_atom(cell_now,atom,5:7) = varargin{1}.coord_cell(cell_now,:) * cell_vector  + str_mtr(atom,:) * cell_vector;
    end
end


%% Writing Bonds File

try
    r_cut = varargin{3};
catch
    r_cut = 1.9;
end

for cell_now = 1 : varargin{1}.num_cells
  	for atom = 1 : num_cell_atoms
        id_now      =   (cell_now - 1) * num_cell_atoms + atom;
        coord(id_now,:)   =   data_atom(cell_now,atom,5:7);
    end
end

box_diag = diag(box_size(:,2)-box_size(:,1));

neighbor_matric = [0 0 0;1 0 0;0 1 0;0 0 1;1 1 0; 1 0 1;0 1 1;1 1 1;
    -1 0 0;0 -1 0;0 0 -1;-1 -1 0; -1 0 -1;0 -1 -1;-1 -1 -1];
try 
    pbc = split(varargin{2});
    judge = ['x';'y';'z'];
    neighbor_modify = zeros(1,3);
    for dim = 1 : length(pbc)
        pos = find(pbc{dim} == judge);
        neighbor_modify(pos) = 1;
    end
    neighbor_matric = neighbor_matric * diag(neighbor_modify);
    neighbor_matric = unique(neighbor_matric,'rows','stable');
end

neighbor_matric = neighbor_matric * diag(varargin{1}.num_cells_vec);

for atom_01 = 1 : num_atoms
    id = 1;
    for atom_02 = atom_01+1 : num_atoms
        r_diff = (coord(atom_02,:) - coord(atom_01,:));
        r_diff = r_diff - neighbor_matric * cell_vector;
        dist = sqrt(sum(r_diff.^2,2));
        judge = dist< r_cut & dist~=0; 
        if find(judge==1) 
            data_bond.id(atom_01,id) = atom_02;
            id = id+1;
        end
    end
    data_bond.num_bonds(atom_01,1) = id-1;      % # of bonds of each atoms
end

data_bond.num_atoms = size(data_bond.id,1);     % # of atoms with bonds

num_bond_types  =   1;
num_bonds       =   sum(data_bond.num_bonds);

%% ---------------------Output-----------------------------
varargout{1}.box_size       =   box_size;
varargout{1}.box_iter       =   box_iter;
varargout{1}.data_atom      =   data_atom;
varargout{1}.data_bond      =   data_bond;
varargout{1}.num_cell_tot   =   num_cell_tot;
varargout{1}.num_cell_atom  =   num_cell_atoms;
varargout{1}.num_atoms      =   num_atoms;
varargout{1}.num_bonds      =   num_bonds;
varargout{1}.num_atom_types =   num_atom_types;
varargout{1}.num_bond_types =   num_bond_types;
varargout{1}.atom_style     =   atom_style;
varargout{1}.atom_mass      =   atom_mass;
varargout{1}.atom_name      =   atom_name;
