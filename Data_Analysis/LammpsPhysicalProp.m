function [varargout]        =   LammpsPhysicalProp(varargin)

%% Description
% Command:
% [varargout] =  LammpsPhysicalProp(name_dump,t_sim,dump_porp,dump_col);
%
% Output:
%
% Temp:
% E_kine
% E_pot

%% Handling PBC issues

coord_corr                  =   LammpsPBC(varargin{1}.coord,varargin{1}.box_size);

%% Calculating Variables

k_b                         =   1.38065e-23;
n_a                         =   6.02214e23;
an2m                        =   1e-10;
fs2s                        =   1e-15;


%% Calculating Kinetic Energy

E_kine                      =   zeros(varargin{1}.num_dims,varargin{1}.num_steps_sim);

for dim = 1 : varargin{1}.num_dims
    E_kine(dim,:)                      =   sum(squeeze(varargin{1}.vel(:,dim,:)).^2);
end

E_kine                      =   E_kine .* 0.5 .* varargin{2};

aaaa
%% Calculating Temp

temp                        =   zeros(varargin{1}.num_dims,varargin{1}.num_steps_sim);

for dim = 1 : varargin{1}.num_dims
    temp(dim,:) =  mean(squeeze(varargin{1}.vel(:,dim,:)).^2);
end

temp                        =   temp .* (varargin{2} * an2m^2 ) ./ (n_a * k_b * fs2s^2);


%% -----------------------Output-----------------------

varargout{1}.E_kine         =   E_kine;
varargout{1}.temp           =   temp;


