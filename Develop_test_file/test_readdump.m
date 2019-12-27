clear all
clc

dump_name = '/Users/zhenyuwei/MD_simulation/dump.obstacle';
dump_prop = ['id type coord_scl'];
dump_col = [1 2 3];
t_sim = 2;

data = LammpsDataReadDump(dump_name,dump_prop,dump_col,t_sim);