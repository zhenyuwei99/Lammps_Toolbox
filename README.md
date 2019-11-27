# Installation

Xpen a new terminal and move to the folder you want to download this code, conducting:

```bash
git clone https://github.com/zhenyuwei99/Lammps_Toolbox.git
sudo matlab
```

In Matlab:

```matlab
pathtool
```
Using **Adding with Subfolders** to add all pathes of Lammps_Tool folders.

Now you can use all of functions.

# Lammps_Toolbox
Matlab functions which can analysis LAMMPS data and generate LAMMPS data file.

## Lammps_Internal

Functions in this folder is in-built one which could be found in 
```bash
[your lammps home]/tools/matlab.
```
readdump* functions are used in LammpsReadDump function in Data_Analysis folder. 

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

<div  align="center">   
<img src="https://github.com/zhenyuwei99/Lammps_Toolbox/raw/master/Images/README/Github_Data_Analysis.png" width = "400" height = "320" alt="Data_Analysis Flowchart" align=center />
</div>   

### LammpsReadDump(dump_name,dump_prop,dump_col,t_sim)

LammpsReadDump function is the core function in Data_Analysis module. A struture containg all information in dump file will be generated and used in the other function for further analysis. In other words, this function should be runed before any other utilization of other functions.

**Example**
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

- alpha is ratio of simulation time to maximum MSD interval. 

### LammpsRDF(data_01,data_02,r_cut,num_bins)

LammpsRDF function is used to calculate Radial Distribution Function (RDF).

- data_01 and data_02 are struture of atom_01, atom_02 generated by LammpsReadDump, respectively. 
- r_cut is the cut off radius inRDF calculation
- num_bins is the number of bins between 0 to r_cut.  

## Str_Generation

<div  align="center">   
<img src="https://github.com/zhenyuwei99/Lammps_Toolbox/raw/master/Images/README/Github_Str_Generation.png" width = "400" height = "500" alt="Data_Analysis Flowchart" align=center />
</div>   

### LammpsStrGenerate(structure,num_cell,lattice_const,atom_type,atom_charge)

LammpsStrGenerate is main function will be used to generate a struture variable containg all information needed to write a .data file.

- struture is a string of which struture will be used. SC BCC FCC DC are supported right now.
- num_cell is a 3 D vectors represents the number of cells in three direction respectively.
- lattice_const is lattice constance of struture.
- atom_type could be in three types: 
   - *Case 1* : atom_type = 1, all atom will be set to type 1;
   - *Case 2* : atom_type = 2, each atom in cell will get anunique type
   - *Case 3* : atom_type is matric. each of atom will be set to type correspond number in matric. Matric lenghth should be equal to # of atoms in cell strickly.
- atom_charge is the charge of atoms, also obey the rules of atom_type.
   - *Case 1* : atom_charge = 0; All atom charge will be set to 0.
   - *Case 2* : atom_charge single number. All atom will be set to the same charge.
   - *Case 3* : atom_charge is a matric. Each atom will be set to a charge correspond number in matric. Same as Case 3 of atom_type, length of matric should be equal to # of atoms in cell

**Example**
```matlab
struture            =   'BCC';
num_cell            =   [2 2 2];
lattice_constant    =   3;
atom_type           =   [1 2];
atom_charge         =   [1 -1];
data                =   LammpsStrGenerate(structure,num_cell,lattice_const,atom_type,atom_charge);
```

### LammpsStrSC, LammpsStrBCC, LammpsStrFCC, LammpsStrDC

All above function will be called determing by variable struture in LammpsStrGenerate. 

### LammpsStrWrite(data,name_output)

- data is the struture generated by LammpsStrGenerate.
- name_output is the name of .data file that you will write.
