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
% Momentum, Kinetic Energy (Total), Temparture , and Density

%% Physical Variable Setting

data_constants              =   LammpsConstants();

%% Calculating Momentum

Momentum                    =   varargin{1}.vel .* varargin{2};

%% Calculating Kinetic Energy

E_kine                      =   Momentum .^ 2 ./ (varargin{2}) ./ 2;

%% Calculating Potential Energy
%% Calculating Pressure

%% Calculating Temp

Temp                        =   squeeze(sum(E_kine)) ./ data_constants.k_b .* (2/3) ./(varargin{1}.num_atoms-1);
Temp                        =   sum(Temp);

%% Calculating Rho

Rho                         =   varargin{1}.num_atoms * varargin{2} / (varargin{1}.box_volume);

%% -----------------------Output-----------------------

varargout{1}.Momentum       =   Momentum .* (data_constants.g2kg/data_constants.n_a) .* (data_constants.an2m/data_constants.fs2s);
varargout{1}.E_kine         =   E_kine .* (data_constants.g2kg/data_constants.n_a) .* (data_constants.an2m/data_constants.fs2s).^2;
varargout{1}.Temp           =   Temp .* (data_constants.g2kg/data_constants.n_a) .* (data_constants.an2m/data_constants.fs2s).^2;
varargout{1}.Rho            =   Rho * data_constants.gm2kg / data_constants.an2m^3;
