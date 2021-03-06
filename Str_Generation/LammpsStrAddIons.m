function data = LammpsStrAddIons(varargin)
%% Description:
%
% *Command*:
% data = LammpsStrAddIons(data,conc,ion_type)
%
% *Input*:
% data      :   structure generated by function LammpsStrGenerate
% conc      :   concentration of solution
% ion_type  :   type of solute, co and counter ions;
%
% *Output*:
% data      :   same as input 'data' variables
%
% *Example*:
% % Assuming data has been generated before through LammpsStrGenerate
% conc      =   0.5
% ion_type  =   'k cl';
% data      =   LammpsStrAddIons(data,conc,ion_type);

%% Supporting List

Ion_List    =   ["K","NA","AL","CL"];

Ion_Mass    =   [39.09 22.99 26.98 35.453];
            
Ion_Charge  =   [1 1 3 -1];

%% Reading Input

data                =   varargin{1};
conc                =   varargin{2};
ion_type            =   split(varargin{3});

coion_type          =   upper(ion_type{1}) == Ion_List;
ctrion_type         =   upper(ion_type{2}) == Ion_List;

num_ions            =   lcm(Ion_Charge(coion_type),abs(Ion_Charge(ctrion_type)) );
num_ions            =   [num_ions/Ion_Charge(coion_type) , num_ions/abs(Ion_Charge(ctrion_type))];

ion_mass            =   [Ion_Mass(coion_type),Ion_Mass(ctrion_type)];
ion_name            =   [Ion_List(coion_type),Ion_List(ctrion_type)];
ion_type_id     	=   [ones(1,num_ions(1)),2*ones(1,num_ions(2))];
ion_charge          =   [Ion_Charge(coion_type) * ones(1,num_ions(1)), Ion_Charge(ctrion_type) * ones(1,num_ions(2))];

num_ions            =   sum(num_ions);
                      
%% Variable Setting

data_const      =   LammpsDataConstants();
wat_density     =   data_const.density_wat * data_const.kg2g / data_const.m2dm^3;     % Unit: g/L
wat_relative    =   16 + 2;

%% Calculate # of solute molecules

num_wat_L       =   wat_density / wat_relative * data_const.n_a;
num_sol_L       =   conc * data_const.n_a;
ratio_sol_wat   =   num_sol_L / num_wat_L;

num_wat         =   data.data_cell.num_cells;       % # of molecules not atoms
num_sols        =   round(num_wat * ratio_sol_wat);

%% Calculating Postion of Ions

cell_id             =   round(1 + (num_wat - 1) * rand(num_sols * num_ions,1));
cell_tilt           =   [0 0 0.5];
ion_info(:,5:7)     =   (data.data_cell.coord_cell(cell_id,:) + cell_tilt) * data.cell_vector;

for sol = 1 : num_sols
    for ion = 1 : num_ions
        current_id = (sol-1) * num_ions + ion;
        ion_info(current_id,1)  =   data.num_atoms + current_id;
        ion_info(current_id,2)  =   data.data_cell.num_cells + current_id;
        ion_info(current_id,3)  =   data.num_atom_types + ion_type_id(ion);
        ion_info(current_id,4)  =   ion_charge(ion);
    end
end

%% Adding Atom Info

data.atom_mass      =   cat(2,data.atom_mass,ion_mass);
data.atom_name      =   cat(2,data.atom_name,ion_name);
data.num_atoms      =   data.num_atoms + num_sols * num_ions;
data.num_atom_types =   data.num_atom_types + length(ion_name);
data.data_atom      =   cat(1,data.data_atom,ion_info);

%% ---------------------Output-----------------------------

varargin{1}         =   data;

