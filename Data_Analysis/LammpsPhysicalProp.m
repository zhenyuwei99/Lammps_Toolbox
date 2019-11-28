function [varargout]        =   LammpsPhysicalProp(varargin)

%% Description
% Command:
%
% [varargout] =  LammpsPhysicalProp(data,mass);
%
% Input:
%
% data: structure created by LammpsReadDump(dump_name,t_sim,dump_prop,dump_col)
% mass: mass of atom in data struture. Currently, only unique atom data
% struture are supported.
%
% Current Supported Physical Properties:
%
% Momentum, Kinetic Energy (Total), and Temparture

%% Calculating Variables

k_b                         =   1.38065e-23;
n_a                         =   6.02214e23;
g2kg                        =   1e-3;
an2m                        =   1e-10;
fs2s                        =   1e-15;


%% Calculating Momentum

Momentum                    =   varargin{1}.vel .* varargin{2};

%% Calculating Kinetic Energy

E_kine                      =   Momentum .^ 2 ./ (varargin{2}) ./ 2;

%% Calculating Temp

Temp                        =   squeeze(sum(E_kine)) ./ k_b .* (2/3) ./(varargin{1}.num_atoms-1);
Temp                        =   sum(Temp);

%% -----------------------Output-----------------------

varargout{1}.Momentum       =   Momentum .* (g2kg/n_a) .* (an2m/fs2s);
varargout{1}.E_kine         =   E_kine .* (g2kg/n_a) .* (an2m/fs2s).^2;
varargout{1}.Temp           =   Temp .* (g2kg/n_a) .* (an2m/fs2s).^2;

