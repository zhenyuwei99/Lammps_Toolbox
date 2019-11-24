function [varargout]    =   LammpsStrGraphene2D(varargin)
%% Description
%
% *Input*
%
% num_cell  : a 2-d factor represent # of cells on direction of two basic
%           vector.

%% Reading Input

num_cell_tot        =   varargin{1}(1) * varargin{1}(2);

%% Struture Variables

lattice_const       =   1.42;                           % Unit: Angstrom

basic_vector        =   [
                        1   0.5
                        0   sqrt(3)/2
                        ];


                    
