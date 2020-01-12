function [varargout] = LammpsDataConstants()

%% Description
%
% *Command*:
%
% data_constants = LammpsDataConstants();
%
% LammpsDataConstants function is used to generate a struture which contain all
% posible physical constants could be used in data analysis.

%% Squeeze Physical constants, energy converter, mass converter, length conveter, time converter

constants_name          =   [
    'k_b n_a  density_wat',...
    ' kcal2j kcalm2j kcalm2t', ...
    ' g2kg kg2g gm2g gm2kg' ,...
    ' an2m an2nm nm2m cm2an dm2m m2dm' ,...
    ' fs2s ps2s ns2s'];
constants_name          =   split(constants_name);
constants_num           =   length(constants_name);

% Physical Constants
k_b                         =   1.38065e-23;
n_a                         =   6.02214e23;
density_wat                 =   1e3;      % Unit: kg/m^3

% Energy Converters
kcal2j                      =   4.184e3;
kcalm2j                     =   kcal2j/n_a;
kcalm2t                     =   kcalm2j/k_b;

% Mass Converters
g2kg                        =   1e-3;
kg2g                        =   1e3;
gm2g                        =   1/n_a;
gm2kg                       =   g2kg/n_a;

% Length Converters
an2m                        =   1e-10;
an2nm                       =   1e-1;
nm2m                        =   1e-9;
cm2an                       =   1e8;
dm2m                        =   1e-1;
m2dm                        =   1/dm2m;

% Time Converters
fs2s                        =   1e-15;
ps2s                        =   1e-12;
ns2s                        =   1e-9;

%% -----------------------Output-----------------------

for constant = 1 : constants_num
    command = ['varargout{1}.',constants_name{constant},'= ',constants_name{constant},';'];
    eval(command);
end
