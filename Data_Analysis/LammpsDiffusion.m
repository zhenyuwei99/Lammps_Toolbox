function [varargout] = LammpsDiffusion(data,alpha)

% function [varargout] = LammpsDiffusion(data,alpha)
%
% Input:
% data: structure created by LammpsReadDump(dump_name,t_sim,dump_prop,dump_col)
% alpha: Ratio of num_steps_sim to num_steps_msd. Default: 10
%

if nargin <= 1
    alpha = 10;
end

%% MSD caculation

data_msd                    =   LammpsMSD(data,alpha);

%% Diffusion Calculation

diffusion                   =   zeros(data.num_atoms,data.num_dims+1);


for atom = 1 : data.num_atoms
    for dim = 1 : data.num_dims + 1
        slope = fit( data_msd.time_msd' , squeeze(data_msd.msd(atom,dim,:)) , 'poly1');
        diffusion(atom,dim) = slope.p1 / 2;
    end
    diffusion(atom,data.num_dims+1) = diffusion(atom,data.num_dims+1) / data.num_dims;
end

diffusion_avg               =   mean(diffusion);
diffusion_error             =   std(diffusion,0,1);

%% -----------------------Output-----------------------

varargout{1}.diffusion          =   diffusion;
varargout{1}.diffusion_avg      =   diffusion_avg;
varargout{1}.diffusion_error    =   diffusion_error;
varargout{1}.msd                =   data_msd.msd;
varargout{1}.msd_error          =   data_msd.msd_error;
varargout{1}.time_msd           =   data_msd.time_msd;
varargout{1}.num_steps_msd      =   data_msd.num_steps_msd;

