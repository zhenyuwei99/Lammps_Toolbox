function [varargout] = LammpsStrSelectCell(varargin)
%% Description
%
% *Command*:
% data_cell_selected = LammpsStrSelectCell(data_cell,select_mode,select_arg)
%
% *Input*:
% data_cell     :   structure that generated by function LammpsStrCellCoord.
% select_mode   :   cylinder are currently supported
% select_arg    :   (1)cylinder: radius and direction of axis. e.g: ['3 z']

%% Supporting Info

Select_Mode     =   ["cylinder"];
Select_Arg      =   [2,1];            % # of args for each modes and postion of last int variable in the arg;

%% Reading Input

data_cell       =   varargin{1};
select_mode     =   find(lower(varargin{2}) == Select_Mode);
input_arg       =   split(varargin{3});
for arg = 1 : Select_Arg(select_mode)
    if arg <= Select_Arg(select_mode,2)
        select_arg(arg) = str2num(input_arg{arg});
    else
        select_arg(arg) = input_arg{arg} - 119;
    end
end

%% Selecting Cell ID

coord                       =   data_cell.coord_cell;
coord_mean                  =   mean(coord,1);
coord(:,select_arg(2))      =   [];
coord_mean(select_arg(2)) =   [];

for dim = 1 : 2
    [~,ind] = min(reshape(abs(bsxfun(@minus,coord,coord_mean(dim))),numel(coord),[]));
    coord_center(dim)   =   coord(ind2sub(size(coord),ind));
end


num_cell_selected           =   0;

for cell = 1 : data_cell.num_cells
    dist = sqrt((coord(cell,:)-coord_center) * (coord(cell,:)-coord_center)');
    if dist <= select_arg(1)
        num_cell_selected = num_cell_selected + 1;
        cell_selected(num_cell_selected) = cell;
    end
end

%% ---------------------Output-----------------------------
varargout{1}.cell_selected          =   cell_selected;
varargout{1}.num_cell_selected      =   num_cell_selected;