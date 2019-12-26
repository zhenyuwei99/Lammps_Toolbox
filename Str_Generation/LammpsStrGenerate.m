function [data] = LammpsStrGenerate(varargin)
%% Description
% LammpsStrGenerate(structure,cell_mode,cell_num,lattice_const,atom_type,atom_charge)
%
% *Input* :
%
% data_cell     :   Structure of information of cells, generated by
%                   function LammpsStrCellCoord
%
% strture       :   strture of lattice (string). SC BCC FCC DC has benn included.
%
% cell_mode     :   a char of mode and args of surface.
%            *sin* : rough surface generated by a sin function. args: direction amplitude period
%               direction: direction of function sin. 1 2 3 correspond to x y z respectively.
%            *l* : linear surface
% cell_num      :   a 3-D vector represents the # of cell in each direction
%               if **'sin'** is chosen in any direction, 
%               # of cells in this direction must be greater than arg **'amplitude'** 
%               and cells in direction of sin function should be integral multiples of arg **'period'**. 
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

if nargin <= 5
    atom_type = 1;
else
    atom_type = varargin{6};
end

if nargin <= 6
    atom_charge = 0;
else
    atom_charge = varargin{7};
end

%% Supporting Information

support_str     =   ["bcc","fcc","sc","dc","si3n4"];
support_judge   =   0;

%% Recognizing Struture

str_id = find(lower(varargin{2}) == support_str);
if str_id
    fprintf("Structure : %s\n",varargin{2})
    try
        fprintf("Lattice constant: %-5.2f\n",varargin{5})
    catch
        pbc = varargin{3};
    end
    support_judge = 1;
end

if support_judge == 0
    fprintf("Error, structure is not supported !\n")
    return;
end

%% Calling corresponding Function

data_cell       =   varargin{1};

try
    func = ['data = LammpsStr',upper(char(support_str(str_id))),'(data_cell,varargin{5},atom_type,atom_charge);'];
    eval(func);
catch
    func = ['data = LammpsStr',upper(char(support_str(str_id))),'(data_cell,pbc);'];
    eval(func);
end