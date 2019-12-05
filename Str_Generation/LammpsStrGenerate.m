function [data] = LammpsStrGenerate(varargin)
%% Description
% LammpsStrGenerate(structure,cell_mode,cell_num,lattice_const,atom_type,atom_charge)
%
% *Input* :
%
% strture       :   strture of lattice (string). SC BCC FCC DC has benn included.
%
% cell_mode     :   String of Modes of struture in three direction. Sin and linear are
%                   supported currently.
%
% cell_num      :   a 3-d vector 
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
% *Example*:
%
% structure = "bcc"; % Note: this variable should be string
% cell_mode = ['sin 2 3 5 l l']; 
% cell_num = [8,10,5]; 
% atom_type = 1;
% atom_charge = 0;
% data = LammpsStrGenerate(structure,cell_mode,cell_num,lattice_const,atom_type,atom_charge);

%% Judging Input

if nargin <= 4
    atom_type = 1;
else
    atom_type = varargin{5};
end

if nargin <= 5
    atom_charge = 0;
else
    atom_charge = varargin{6};
end

%% Supporting Information

support_str     =   ["bcc","fcc","sc","dc"];
support_num     =   length(support_str);
support_judge   =   0;

%% Recognizing Struture

for str = 1 : support_num
    if lower(varargin{1}) == support_str(str)
        str_id = str;
        fprintf("Structure : %s\n",varargin{1})
        fprintf("Lattice constant: %-5.2f\n",varargin{4})
        support_judge = 1;
    end
end

if support_judge == 0
    fprintf("Error, structure is not supported !\n")
    return;
end

%% Calling corresponding Function

data_cell       =   LammpsStrCellCoord(varargin{2},varargin{3});

func = ['data = LammpsStr',upper(char(support_str(str_id))),'(data_cell,varargin{4},atom_type,atom_charge);'];
eval(func);