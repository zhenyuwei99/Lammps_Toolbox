function [varargout]    =   LammpsDataReadDump(dump_name,dump_prop,dump_col,t_sim)

%% Description
% Command:
% [varargout]    =   LammpsDataReadDump(dump_name,dump_prop,dump_col,t_sim)
%
% *Input*:
% dump_name: name of dump file
% dump_prop: String of properties in the dump file
% dump_col: The first column corresponds to each properties in dump_type
% t_sim: simulation time. Unit: ns
%
% *Example*:
% dump_prop = ['id type coord vel'];
% dump_col = [1 2 3 6];
% 
% *Thanks*:
% A lot of inspirations of code in 'Reading Dump File' part is absorbed from
% codes of Arun K. Subramaniyan.
%
% sarunkarthi@gmail.com
% http://web.ics.purdue.edu/~asubrama/pages/Research_Main.htm
% School of Aeronautics and Astronautics
% Purdue University, West Lafayette, IN - 47907, USA.

%% Reading Dump File

try
    dump = fopen(dump_name,'r');
catch
    error('Dumpfile not found');
end

output_id           =   1; 
progress_flag       =   0;      % Flag determing when data recording starts

while feof(dump) == 0
    current_line = fgetl(dump);   
    if (strncmp(current_line,'ITEM: TIMESTEP',numel('ITEM: TIMESTEP')))
        data.timestep(output_id) = str2num(fgetl(dump));
    else
        if (strncmp(current_line,'ITEM: NUMBER OF ATOMS',numel('ITEM: NUMBER OF ATOMS')))
            data.num_atoms(output_id) = str2num(fgetl(dump)); 
        else
            if (strncmp(current_line,'ITEM: BOX BOUNDS',numel('ITEM: BOX BOUNDS')))
                for dim = 1 : 3
                    data.box_range(dim,output_id,:) = str2num(fgetl(dump));
                end
            else
                if (strncmp(current_line,'ITEM: ATOMS',numel('ITEM: ATOMS')))
                    for atom = 1 : data.num_atoms(output_id)
                        data.atom_data(atom,:,output_id) = str2num(fgetl(dump));
                    end
                    output_id = output_id + 1;
                end
            end
        end
    end
end

%% Simulation   variable

dump_prop               =   split(dump_prop);
num_props               =   length(dump_col);
[num_atoms,num_col_tot,num_steps_sim]   =   size(data.atom_data);
num_dims                =   3;

time_sim                =   [1:num_steps_sim] ./ (num_steps_sim / t_sim);

for dim = 1 : num_dims
    box_range(dim,:)        =   mean(squeeze(data.box_range(dim,:,:)));
    box_size_time(dim,:,:)  =   data.box_range(dim,:,2) - data.box_range(dim,:,1);
end
box_size_avg            =   box_range(:,2) - box_range(:,1);    % 3-d vector of box size
box_diag                =   diag(box_size_avg);
box_volume              =   1;

for dim = 1 : num_dims
    box_volume = box_volume * box_size_avg(dim);
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
    varargout{1}.box_range      =   box_range;
    varargout{1}.box_size_time  =   box_size_time;
    varargout{1}.box_size       =   box_size_avg;
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
    for type = 1 : num_types
        varargout{type}.num_steps_sim   =   num_steps_sim;
        varargout{type}.num_props       =   num_props;
        varargout{type}.num_dims        =   num_dims;
        varargout{type}.t_sim           =   t_sim;
        varargout{type}.time_sim        =   time_sim;
        varargout{type}.box_range     	=   box_range;
        varargout{type}.box_size_time   =   box_size_time;
        varargout{type}.box_size        =   box_size_avg;
        varargout{type}.box_diag        =   box_diag;
        varargout{type}.box_volume      =   box_volume;
        command = ['varargout{type}.num_atoms = num_atom_',num2str(id_type(type)),';'];
        eval(command);
        for prop = 1 : num_props
            if prop < num_props
                command = ['varargout{type}.',dump_prop{prop},'= data.atom_data(:, dump_col(prop):dump_col(prop+1)-1 ,:);'];
            else
                command = ['varargout{type}.',dump_prop{prop},'= data.atom_data(:,dump_col(prop):num_col_tot,:);'];
            end
            eval(command);
            if prop < num_props
               	command = ['varargout{type}.',dump_prop{prop},'= data_atom_',num2str(id_type(type)),'(:, dump_col(prop):dump_col(prop+1)-1 ,:);'];
            else
              	command = ['varargout{type}.',dump_prop{prop},'= data_atom_',num2str(id_type(type)),'(:,dump_col(prop):num_col_tot,:);'];
            end
          	eval(command);
        end
    end
end

