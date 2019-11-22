function [varargout]    =   LammpsReadDump(name_dump,t_sim,dump_prop,dump_col)

%% Description
% Command:
%[varargout]    =   LammpsReadDump(name_dump,t_sim,dump_prop,dump_col);
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

data                    =   readdump_all(name_dump);

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

%% Rearranging raw data

for step = 1 : num_steps_sim
    data.atom_data(:,:,step)     =   sortrows(squeeze(data.atom_data(:,:,step)),1);
end

%% -----------------------Output-----------------------

varargout{1}.num_atoms      =   num_atoms;
varargout{1}.num_steps_sim  =   num_steps_sim;
varargout{1}.num_props      =   num_props;
varargout{1}.num_dims       =   num_dims;
varargout{1}.t_sim          =   t_sim;
varargout{1}.time_sim       =   time_sim;
varargout{1}.box_size       =   box_size;
varargout{1}.box_diag       =   box_diag;

for prop = 1 : num_props
    if prop < num_props
        command = ['varargout{1}.',dump_prop{prop},'= data.atom_data(:, dump_col(prop):dump_col(prop+1)-1 ,:);'];
    else
        command = ['varargout{1}.',dump_prop{prop},'= data.atom_data(:,dump_col(prop):num_col_tot,:);'];
    end
    eval(command);
end
