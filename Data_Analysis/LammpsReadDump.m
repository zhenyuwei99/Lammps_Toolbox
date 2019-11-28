function [varargout]    =   LammpsReadDump(dump_name,dump_prop,dump_col,t_sim)

%% Description
% Command:
% [varargout]    =   LammpsReadDump(dump_name,dump_prop,dump_col,t_sim)
%
% Input:
% name_dump: name of dump file
% t_sim: simulation time. Unit: ns
% dump_type: String of properties dumped in the dump file
% dump_col: The first column corresponds to each properties in dump_type
%
% Example
% dump_prop = ['id type coord vel'];
% dump_col = [1 2 3 6];

%% Reading data

data                    =   readdump_all(dump_name);

%% Simulation   variable

dump_prop               =   split(dump_prop);
num_props               =   length(dump_col);
num_atoms               =   size(data.atom_data,1);
num_col_tot             =   size(data.atom_data,2);
num_steps_sim           =   size(data.atom_data,3);
num_dims                =   3;

time_sim                =   [1:num_steps_sim] ./ (num_steps_sim / t_sim);

box_range               =   zeros(num_dims,2);
box_range(1,:)          =   mean(data.x_bound);
box_range(2,:)          =   mean(data.y_bound);
box_range(3,:)          =   mean(data.z_bound);
box_size                =   box_range(:,2) - box_range(:,1);    % 3-d vector of box size
box_diag                =   diag(box_size);
box_volume              =   1;

for dim = 1 : num_dims
    box_volume = box_volume * box_size(dim);
end

%% Rearranging raw data

for i = 1 : length(dump_col)
    if dump_prop{i} == "id"
        col_id = dump_col(i);
        break
    end
end

for step = 1 : num_steps_sim
    data.atom_data(:,:,step)     =   sortrows(squeeze(data.atom_data(:,:,step)),col_id);
end

%% Judging Atom type

for i = 1 : length(dump_col)
    if dump_prop{i} == "type"
        col_type = dump_col(i);
        break
    end
end

id_type                 =   unique(squeeze(data.atom_data(:,col_type,1)));
num_types               =   length(id_type);

if num_types == 1
    mode_output             =   1;
else
    mode_output             =   2;
    for type = 1 : num_types
        command = ['num_atom_',num2str(id_type(type)),'= sum( squeeze(data.atom_data(:,col_type,1)) == ' , num2str(id_type(type)),' );'];
        eval(command);
        command = ['data_atom_',num2str(id_type(type)),'= data.atom_data(find(squeeze(data.atom_data(:,col_type,1))==',num2str(id_type(type)),'),:,:);'];
        eval(command);
    end
end     


%% -----------------------Output-----------------------
if mode_output == 1
    varargout{1}.num_atoms      =   num_atoms;
    varargout{1}.num_steps_sim  =   num_steps_sim;
    varargout{1}.num_props      =   num_props;
    varargout{1}.num_dims       =   num_dims;
    varargout{1}.t_sim          =   t_sim;
    varargout{1}.time_sim       =   time_sim;
    varargout{1}.box_size       =   box_size;
    varargout{1}.box_diag       =   box_diag;
    varargout{1}.box_volume     =   box_volume;
    
    for prop = 1 : num_props
        if prop < num_props
            command = ['varargout{1}.',dump_prop{prop},'= data.atom_data(:, dump_col(prop):dump_col(prop+1)-1 ,:);'];
        else
            command = ['varargout{1}.',dump_prop{prop},'= data.atom_data(:,dump_col(prop):num_col_tot,:);'];
        end
        eval(command);
    end
end

if mode_output == 2
    varargout{1}.num_atoms      =   num_atoms;
    for type = 1 : num_types
        command = ['varargout{',num2str(type),'}.num_atoms = num_atom_',num2str(id_type(type)),';'];
        eval(command);
    end
    varargout{1}.num_steps_sim  =   num_steps_sim;
    varargout{1}.num_props      =   num_props;
    varargout{1}.num_dims       =   num_dims;
    varargout{1}.t_sim          =   t_sim;
    varargout{1}.time_sim       =   time_sim;
    varargout{1}.box_size       =   box_size;
    varargout{1}.box_diag       =   box_diag;
    varargout{1}.box_volume     =   box_volume;

    for prop = 1 : num_props
        if prop < num_props
            command = ['varargout{1}.',dump_prop{prop},'= data.atom_data(:, dump_col(prop):dump_col(prop+1)-1 ,:);'];
        else
            command = ['varargout{1}.',dump_prop{prop},'= data.atom_data(:,dump_col(prop):num_col_tot,:);'];
        end
        eval(command);
        for type = 1 : num_types
            if prop < num_props
                command = ['varargout{1}.',dump_prop{prop},'_atom_',num2str(id_type(type)),'= data_atom_',num2str(id_type(type)),'(:, dump_col(prop):dump_col(prop+1)-1 ,:);'];
            else
                command = ['varargout{1}.',dump_prop{prop},'_atom_',num2str(id_type(type)),'= data_atom_',num2str(id_type(type)),'(:,dump_col(prop):num_col_tot,:);'];
            end
            eval(command);
        end
    end
end

