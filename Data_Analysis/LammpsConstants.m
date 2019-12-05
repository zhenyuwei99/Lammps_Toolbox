function [varargout] = LammpsConstants()

%% Description
%
% *Command*:
%
% data_constants = LammpsConstants();
%
% LammpsConstants function is used to generate a struture which contain all
% posible physical constants could be used in data analysis.

%% Squeeze Physical constants, energy converter, mass converter, length conveter, time converter

constants_name          =   ['k_b n_a kcal2j kcalm2j kcalm2t g2kg gm2kg an2m nm2m fs2s ps2s'];
constants_name          =   split(constants_name);
                        
constants_num           =   length(constants_name);

k_b                         =   1.38065e-23;
n_a                         =   6.02214e23;
kcal2j                      =   4.184e3;
kcalm2j                     =   kcal2j/n_a;
kcalm2t                     =   kcalm2j/k_b;
g2kg                        =   1e-3;
gm2kg                       =   g2kg/n_a;
an2m                        =   1e-10;
nm2m                        =   1e-9;
fs2s                        =   1e-15;
ps2s                        =   1e-12;

%% -----------------------Output-----------------------

for constant = 1 : constants_num
    command = ['varargout{1}.',constants_name{constant},'= ',constants_name{constant},';'];
    eval(command);
end
