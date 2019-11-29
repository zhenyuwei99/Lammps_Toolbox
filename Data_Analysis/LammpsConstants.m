function [varargout] = LammpsConstants()

%% Description
%
% *Command*:
%
% data_constants = LammpsConstants();
%
% LammpsConstants function is used to generate a struture which contain all
% posible physical constants could be used in data analysis.

%% Variables

k_b                         =   1.38065e-23;
n_a                         =   6.02214e23;
g2kg                        =   1e-3;
an2m                        =   1e-10;
fs2s                        =   1e-15;
ps2s                        =   1e-12;

% Squeeze Physical constants, energy converter, mass converter, length conveter, time converter

constants_name          =   ['k_b n_a kcal2j kcalm2j kcalm2t g2kg gm2kg an2m nm2m fs2s ps2s'];
constants_name          =   split(constants_name);
constants_values        =   [
                            1.38065e-23
                            6.02214e23
                            4.184e3
                            4.184e3/6.02214e23
                            4.184e3/6.02214e23/k_b
                            1e-3
                            1e-3/6.02214e23
                            1e-10
                            1e-9
                            1e-15
                            1e-12
                            ];
                        
 constants_num          =   length(constants_values);

%% -----------------------Output-----------------------

for constant = 1 : constants_num
    command = ['varargout{1}.',constants_name{constant},'= constants_values(constant);'];
    eval(command);
end
