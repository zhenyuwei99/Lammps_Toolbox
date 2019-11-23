# Lammps_Toolbox
Matlab functions which can analysis LAMMPS data and generate LAMMPS data file.

## Lammps_Internal

Functions in this folder is in-built one which could be found in [your lammps home]/tools/matlab. readdump* functions are used in LammpsReadDump function in Data_Analysis folder. 

Thanks  Author :  
>Arun K. Subramaniyan
>
>sarunkarthi@gmail.com
>
>http://web.ics.purdue.edu/~asubrama/pages/Research_Main.htm
>
>School of Aeronautics and Astronautics
>
>Purdue University, West Lafayette, IN - 47907, USA.

## Data_Analysis



### LammpsReadDump(dump_name,dump_prop,dump_col,t_sim)

LammpsReadDump function is the core function in Data_Analysis module. A struture containg all information in dump file will be generated and used in the other function for further analysis. In other words, this function should be runed before any other utilization of other functions.

Example 
```matlab
dump_name   =   'example.dump';
dump_prop   =   ['id type coord vel'];
dump_col    =   [1 2 3 6];
t_sim       =   5;                      % Unit: time unit;

data        =   LammpsReadDump(dump_name,dump_prop,dump_col,t_sim);
```

Notice: martic 'coord' should be contained in output struture variable. Or the name of coordinate data in dump_prop should be 'coord' (saying annotation in LammpsReadDump.m for further information)

### LammpsPBC(data)

LammpsPBC function is used to handle Periodic Boundary Condition (PBC) issues. Coordinate file will be unwarped if PBC is used in MD simulation;



### LammpsMSD(data)

LammpsMSD function is used to calculate Meas Square Displacement (MSD). 

### LammpsDiffusion(data,alpha)

LammpsDiffusion function is used to calculate diffusion coefficients

alpha is ratio of simulation time to maximum MSD interval. 

### LammpsRDF