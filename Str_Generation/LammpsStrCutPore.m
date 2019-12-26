function [varargout] = LammpsStrCutPore(varargin)
%% Description
%
% *Command*:
% data_cell = LammpsStrCutPore(data_cell,r,dire);
%
% *Input*
% data_cell : Structure created by function LammpsStrCellCoord;
% r         : Radius of pore, Unit: Lattice Constant;
% dire      : Axis along which pore will be constructed Example: ['z'];
%
% *Notice*
% This function should followed function LammpsStrCellCoord;
%
% *Example*
% data_cell = LammpsStrCutPore(data_cell, 2 , 'z');

%% Reading Input

dire        =   find((varargin{3} == ['x';'y';'z'])==1);
data_cell   =   varargin{1};
r           =   varargin{2};
cell_center =   round((max(data_cell.coord_cell) - min(data_cell.coord_cell)) / 2);

%% Setting Variables

num_dims    =   3;
flag        =   ones(data_cell.num_cells,1);

%% Deleting Cells

for dim = 1 : num_dims
    if dim == dire
        continue
    end
    flag = data_cell.coord_cell(:,dim) <= (cell_center(dim) + r) & ...
            data_cell.coord_cell(:,dim) >= (cell_center(dim) - r) & flag;
end

id_atoms_delete     =   find(flag);
num_atoms_delete    =   length(id_atoms_delete);

data_cell.num_cells =   data_cell.num_cells - num_atoms_delete;
data_cell.coord_cell(id_atoms_delete,:) = [];

%% ---------------------Output-----------------------------

varargout{1}        =   data_cell;     
