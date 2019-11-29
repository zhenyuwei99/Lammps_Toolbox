function [varargout] = LammpsMSD(data,alpha)

% function [varargout] = LammpsMSD(name_dump,t_sim,col_coord,alpha)
% Input:
% data: structure created by LammpsReadDump(dump_name,t_sim,dump_prop,dump_col)
% alpha: Ratio of num_steps_sim to num_steps_msd. Default: 10

if nargin <= 1
    alpha = 10;
end

%% Handling PBC issues

coord_corr              =   LammpsPBC(data);

%% Calculating MSD

num_steps_msd           =   round(data.num_steps_sim / alpha);    
msd                     =   zeros([data.num_atoms,data.num_dims+1,num_steps_msd]);
msd_error            	=   zeros([data.num_atoms,data.num_dims+1,num_steps_msd]);
time_msd                =   [1:num_steps_msd] ./ (num_steps_msd / data.t_sim * alpha);

for step = 1 : num_steps_msd
    for dim = 1 : data.num_dims
        msd(:,dim,step) =  mean( squeeze(( coord_corr(:,dim,step+1:data.num_steps_sim) ...
                                         - coord_corr(:,dim,1:data.num_steps_sim-step) ).^2) , 2);
        msd_error(:,dim,step) =  std( squeeze(( coord_corr(:,dim,step+1:data.num_steps_sim) ...
                                         - coord_corr(:,dim,1:data.num_steps_sim-step) ).^2) ,0, 2);
    end
    msd(:,data.num_dims+1,step) = sum(squeeze(msd(:,1:data.num_dims,step)),2);
end

%% -----------------------Output-----------------------
varargout{1}.msd            =   msd;
varargout{1}.msd_error      =   msd_error;
varargout{1}.time_msd       =   time_msd;
varargout{1}.num_steps_msd  =   num_steps_msd;
