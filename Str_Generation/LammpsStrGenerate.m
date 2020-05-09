function [data] = LammpsStrGenerate(varargin)
%% Description
% *Command*:
%
% Type1: LammpsStrGenerate(data_cell,structure,lattice_const,atom_type,atom_charge)
% Type2: LammpsStrGenerate(data_cell,structure,pbc)
% Type1 is made for models with specific structure but no specific element,
% Type2 is made for models with specific element and structure like Si3N4;
%
%
% *Input* :
%
% data_cell     :   Structure of information of cells, generated by
%                   function LammpsStrCellCoord
%
% structure     :   strture of lattice (string). SC BCC FCC DC has benn included.
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
%
% pbc           :   determining which boundary will be applied with
%                   PBC condition for bonds definitions.
%
% *Example 1*:
%
% structure = "bcc"; % Note: this variable should be string
% cell_mode = ['sin 2 3 5 l l'];
% cell_num = [8,10,5];
% data_cell = LammpsStrCellCoord(cell_mode,cell_num);
% atom_type = 1;
% atom_charge = 0;
% data = LammpsStrGenerate(data_cell,structure,lattice_const,atom_type,atom_charge);
%
% *Example 2*:
%
% structure = 'si3n4';
% cell_vec = [4 4 3];
% data_cell = LammpsStrCellCoord(structure,cell_vec);
% data = LammpsStrGenerate(data_cell,structure,['x y']);

%% Reading Input

data_cell       =   varargin{1};
structure       =   varargin{2};

%% Supporting List

str_basic       =   ["bcc","fcc","sc","dc"];
str_crystal     =   ["si3n4","si3n4_ort","sio2","si","graphene","graphene_ort"];
str_wat         =   ["tip3p","tip3p_hex","spc","spce"];

str_support     =   [str_basic,str_crystal,str_wat];

support_judge   =   0;

%% Recognizing Struture

str_id = find(lower(structure) == str_support);

if str_id
    fprintf('\n-------------------------\n')
    fprintf("\nStructure : %s\n",structure)
    try
        if isa(varargin{3},'float')
            fprintf("Lattice constant: %-5.2f\n",varargin{3})
            type    =   1;
        else
            pbc     =   varargin{3};
            type    =   2;
        end
    catch
        pbc     =   ['x y z'];
        type    =   2;
    end
    support_judge = 1;
end

if support_judge == 0
    fprintf("Error, structure is not supported !\n")
    return;
end

%% Reading Input

if type == 1
    try
        atom_type   =   varargin{4};
    catch
        atom_type   =   1;
    end
    try
        atom_charge =   varargin{5};
    catch
        atom_charge =   1;
    end 
else
    try 
        bond_arg    =   varargin{4};
    catch
        bond_arg    =   0;
    end
end

%% Calling corresponding Function

%{
func = ['data = LammpsStr',upper(char(support_str(str_id))),'(data_cell,pbc);'];
    eval(func);
%}

try
    func = ['data = LammpsStr',upper(char(str_support(str_id))),'(data_cell,pbc,bond_arg);'];
    eval(func);
catch
    func = ['data = LammpsStr',upper(char(str_support(str_id))),'(data_cell,varargin{3},atom_type,atom_charge);'];
    eval(func);
end

%% Visuliaztion of box size

fprintf('\nBox_size:\n')
for dim = 1 : size(data.box_size,1)
    fprintf('%s:\t%.2f\t%.2f\n',dim+119,data.box_size(dim,1),data.box_size(dim,2));
end
fprintf('\n-------------------------\n')
