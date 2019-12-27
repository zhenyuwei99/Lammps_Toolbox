function [varargout] = LammpsDataReadLog(log_name,log_prop)
%% Description:
% *Command*:
% [varargout] = LammpsDataReadLog(log_name,log_prop);
%
% *Input*:
% log_name: name of log file.
% log_prop: string of properties in log file; Same as keywords in
%           thermal_style command.
%
% *Example*
% log_prop: ['step temp press etotal vol'];
%
% Notice: Squeeze of log_prop should be follow the order in log file
%         strictly.

%% Checking log file

try
    log = fopen(log_name,'r');
catch
    error('Log file not found!');
end

%% Keywords of input and corresponding output name. See Lammps Manual for details

input_table      	=   split(['step elapsed elaplong dt time ', ...
                          'cpu tpcpu spcpu cpuremain part timeremain ', ...
                          'atoms temp press pe ke etotal enthalpy ', ...
                          'evdwl ecoul epair ebond eangle edihed eimp ', ...
                          'emol elong etail ', ...
                          'vol density lx ly lz xlo xhi ylo yhi zlo zhi ', ...
                          'xy xz yz xlat ylat zlat ', ...
                          'bonds angles dihedrals impropers ', ...
                          'pxx pyy pzz pxy pxz pyz ', ...
                          'fmax fnorm nbuild, ndanger ', ...
                          'cella cellb cellc cellalpha cellbeta cellgamma']);
                  
output_table     	=   split(['Step Elapsed Elaplong Dt Time ',...
                            'CPU T/CPU S/CPU CPULeft Part TimeoutLeft ',...
                            'Atoms Temp Press PotEng KinEng TotEng Enthalpy ',...
                            'E_vdwl E_coul E_pair E_bond E_angle E_dihed E_impro '...
                            'E_mol E_long E_tail ',...
                            'Volume Density Lx Ly Lz Xlo Xhi Ylo Yhi Zlo Zhi ',...
                            'Xy Xz Yz Xlat Ylat Zlat ',...
                            'Bonds Angles Diheds Impros ',...
                            'Pxx Pyy Pzz Pxy Pxz Pyz ',...
                            'Fmax Fnorm Nbuild Ndanger ',...
                            'Cella Cellb Cellc CellAlpha CellBeta CellGamma']);

                        
 num_keys           =   length(input_table);                                 
                        
%% Reading Input

input_keys          =   split(log_prop);
num_inputs          =   length(input_keys);   
input_pos           =   zeros(num_inputs,1);
num_corresponds     =   0;

for key = 1 : num_keys
    for input = 1 : num_inputs
        if string(lower(input_keys{input})) == string(input_table{key})
            input_pos(num_corresponds+1) = key;
            num_corresponds = num_corresponds+1;
            if num_corresponds == num_inputs
                break;
            end
        end
    end
end

if num_corresponds < num_inputs
    fprintf(['Error, input keys ',num2str(num_corresponds),' does not supported. Checking spelling'])
    return
end

%% Reading Log file

output_id           =   1; 
progress_flag       =   0;      % Flag determing when data recording starts

while feof(log) == 0
    current_line = fgetl(log);
    
    if (strncmp(current_line,'Loop time of',numel('Loop time of')))
        break
    end
    if progress_flag
        data(output_id,:) = str2num(current_line);
        output_id = output_id + 1;
    end
    if (strncmpi(current_line,output_table{input_pos(1)},numel(output_table{input_pos(1)})))
        progress_flag = 1;
    end
end


%% -----------------------Output-----------------------

varargout{1}.Plot_x = [1 : size(data,1)]';

for input = 1 : num_inputs
    command = ['varargout{1}.',output_table{input_pos(input)},'=data(:,input);'];
    eval(command);
end
    
    
