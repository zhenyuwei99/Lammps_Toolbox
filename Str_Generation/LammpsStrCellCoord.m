function [varargout] = LammpsStrCellCoord(varargin)

%% Description
%
% *Command*:
% data_cell = LammpsCellCoord(cell_mode,cell_num)
%
% *Input*:
% cell_mode: String of Modes of struture in three direction. Sin and linear are
%       supported currently. If sin is choosed a arg of amplitude (units: 
%       lattice constants) should be attached in the Modes string. 
%       See example for detail.
% cell_num: num of cells in each direction
%
% *Example*:
% cell_mode = ['sin 2 linear linear'];
% cell_num = [10 10 10];
% data_cell = LammpsCellCoord(cell_mode,cell_num);

%% Supported List of Mode

Mode_list                   =   ["sin","l"];
Mode_num_arg                =   [3,0];
Mode_num                    =   length(Mode_num_arg);


%% Reading Input

mode                        =   split(varargin{1});
num_args_mode               =   length(mode);
num_dims                    =   3;
mode_input                  =   zeros(num_dims,max(Mode_num_arg+1));

dim                 =   1;
for arg = 1 : num_args_mode
    for Mode = 1 : Mode_num
        if(mode{arg} == Mode_list(Mode))
            mode_input(dim,1) = Mode;
            if Mode_num_arg(Mode)
                for pos = 1 : Mode_num_arg(Mode)
                    arg = arg + 1;
                    mode_input(dim,1+pos) = str2num(mode{arg});
                end
            end
            dim = dim + 1;
            continue
        end
    end
end

%% Generating Coord of Cell
num_cells(1)            	=   varargin{2}(1);
num_cells(2)             	=   varargin{2}(2);
num_cells(3)                =   varargin{2}(3);
num_cells_tot                   =   num_cells(1) * num_cells(2) * num_cells(3);

coord_cell                  =   zeros(num_cells_tot,num_dims);

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
    if(mode_input(dim,1) == 1)
        for x = 1 : num_cells(1)
            for y = 1 : num_cells(2)
                for z = 1 : num_cells(3)
                    command = ['judge = mode_input(dim,3) * sin(',char(119+mode_input(dim,2)),'/mode_input(dim,4)*2*pi) + num_cells(dim) - mode_input(dim,3);'];
                    eval(command);
                    cell_now = (x-1)*num_cells(2)*num_cells(3) + (y-1)*num_cells(3) + z;
                    if coord_cell(cell_now,dim) >= judge
                        coord_cell(cell_now,:) = -1;
                    end
                end
            end
        end 
    end
end

coord_cell(find(coord_cell(:,1)==-1),:)   =   [];
num_cells_tot                   =   size(coord_cell,1);
box_size                    =   [min(coord_cell);max(coord_cell)+1]';


%% -----------------------Output-----------------------

varargout{1}.mode_input         =   mode_input;
varargout{1}.coord_cell         =   coord_cell;
varargout{1}.box_size           =   box_size;
varargout{1}.num_cells          =   num_cells_tot;
            