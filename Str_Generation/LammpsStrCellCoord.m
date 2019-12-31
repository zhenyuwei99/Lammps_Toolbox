function [varargout] = LammpsStrCellCoord(varargin)
%% Description
%
% *Command*:
% data_cell = LammpsStrCellCoord(cell_vec)
%
% *Input*:
% cell_vec      : # of cells in each direction
%
% *Example*:
% cell_vec = [10 10 10];
% data_cell = LammpsStrCellCoord(cell_vec);

%% Reading Input

cell_vec        =   varargin{1};

%% Generating Coord of Cell

num_dims      	=   length(cell_vec);
num_cells_tot	=   1;

for dim = 1 : num_dims
    num_cells(dim)  =   cell_vec(dim);
    num_cells_tot   =   num_cells_tot * num_cells(dim);
end

for x = 1 : num_cells(1)
    for y = 1 : num_cells(2)
        for z = 1 : num_cells(3)
            cell_now = (x-1)*num_cells(2)*num_cells(3) + (y-1)*num_cells(3) + z;
            coord_cell(cell_now,1) = x - 1;
            coord_cell(cell_now,2) = y - 1;
            coord_cell(cell_now,3) = z - 1;
        end
    end
end

for dim = 1 : num_dims
    box_size(dim,:) =   [min(coord_cell(:,dim));max(coord_cell(:,dim))+1]';
end


%% -----------------------Output-----------------------

varargout{1}.coord_cell         =   coord_cell;
varargout{1}.box_size           =   box_size;
varargout{1}.num_cells_vec      =   cell_vec;
varargout{1}.num_cells          =   num_cells_tot;
            