clear all
clc

name_dump_01 = '/home/zhenyu/MD_simulation/Diffusion/Water_Model_LAMMPS/dump/0.5ns/hydrogen_vel.dump';
name_dump_02 = '/home/zhenyu/MD_simulation/Diffusion/Water_Model_LAMMPS/dump/0.5ns/oxygen_vel.dump';
t_sim = 0.5;
dump_prop = ['id type coord vel'];
dump_col = [1 2 3 6];

data_01    =    LammpsReadDump(name_dump_01,t_sim,dump_prop,dump_col);
data_02    =    LammpsReadDump(name_dump_02,t_sim,dump_prop,dump_col);

prop_01    =   LammpsPhysicalProp(data_01,1);
prop_02    =   LammpsPhysicalProp(data_02,16);

E_kine_tot = sum(prop_01.E_kine + prop_02.E_kine);
num_atoms_tot = data_01.num_atoms + data_02.num_atoms;

E_kine_avg = E_kine_tot / num_atoms_tot;

k_b                         =   1.38065e-23;
n_a                         =   6.02214e23;
an2m                        =   1e-10;
fs2s                        =   1e-15;

Temp =  E_kine_avg / k_b / n_a;

