function [varargout] = LammpsStrMove(varargin)
%% Description
%
% *Command*:
% data = LammpsStrMove(data,move_vec)
%
% *Input*:
% data      :   data is a structure generated by LammpsStrGenerate function
% move_vec  :   move_vec is a 3-d vector determing a uniform movements of
%               box and atoms coordinates

%% Reading Input

data        =   varargin{1};
move_vec    =   varargin{2};

flag_minus  =   find(move_vec < 0);

%% Rearranging Data

if flag_minus
    data.data_atom(:,flag_minus+4) = -data.data_atom(:,flag_minus+4);
    data.box_size(flag_minus,:) = -data.box_size(flag_minus,:);
    temp = data.box_size(flag_minus,2);
    data.box_size(flag_minus,2) = data.box_size(flag_minus,1);
    data.box_size(flag_minus,1) = temp;
end

data.box_size       =   data.box_size + move_vec';
data.data_atom(:,5:7) =   data.data_atom(:,5:7) + move_vec;

%% ---------------------Output-----------------------------

varargout{1}        =   data;