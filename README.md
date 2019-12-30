# Installation

Open a new terminal and move to the folder you want to download this code, conducting:

## Linux:
```bash
git clone https://github.com/zhenyuwei99/Lammps_Toolbox.git
sudo matlab
```
## MacOS:
```bash
git clone https://github.com/zhenyuwei99/Lammps_Toolbox.git
```

In Matlab:

```matlab
pathtool
```
Using **Adding Folder** to add **'Data_Analysis'** and **'Str_Generation'** folders.

Now you can use all of functions.

# Lammps_Toolbox
Matlab functions which can analysis LAMMPS data and generate LAMMPS data file.

## Data_Analysis

<div  align="center">   
<img src="https://github.com/zhenyuwei99/Lammps_Toolbox/raw/master/Images/README/Github_DataAnalysis.png" width = "400" height = "320" alt="Data_Analysis Flowchart" align=center />
</div>   

### [LammpsDataReadDump(dump_name,dump_prop,dump_col,t_sim)](https://github.com/zhenyuwei99/Lammps_Toolbox/blob/master/Data_Analysis/LammpsDataReadDump.m)

**LammpsDataReadDump** function is the core function in Data_Analysis module. A structure contaning all information in dump file will be generated and used in the other function for further analysis. In other words, this function should be runned before any other utilization of other functions.

**Example**
```matlab
dump_name   =   'example.dump';
dump_prop   =   ['id type coord vel'];
dump_col    =   [1 2 3 6];
t_sim       =   5;                      % Unit: time unit;

data        =   LammpsDataReadDump(dump_name,dump_prop,dump_col,t_sim);
```

Notice: martix 'coord' should be contained in output structure variable. Or the name of coordinate data in dump_prop should be 'coord' (saying annotation in LammpsDataReadDump.m for further information)

### [LammpsDataReadLog(log_name,log_prop)](https://github.com/zhenyuwei99/Lammps_Toolbox/blob/master/Data_Analysis/LammpsDataReadLog.m)

**LammpsDataReadLog** function is used to read the data in log function.

**Example**
```matlab
log_name = 'log.lammps';
log_prop = ['step temp press etotal vol'];
data_log = LammpsDataReadLog(log_name,log_prop);

```
Notice: Squeeze of log_prop should be follow the order in log file strictly.

### [LammpsDataConstants()](https://github.com/zhenyuwei99/Lammps_Toolbox/blob/master/Data_Analysis/LammpsDataConstants.m)

**LammpsDataConstans** function is used to generate a structure which contains many useful constants and unit converters in data anlysis of MD simulation.

### [LammpsDataPBC(data)](https://github.com/zhenyuwei99/Lammps_Toolbox/blob/master/Data_Analysis/LammpsDataPBC.m)

**LammpsDataPBC** function is used to handle Periodic Boundary Condition (PBC) issues. Coordinate file will be unwarpped if PBC is used in MD simulation;

### [LammpsDataMSD(data)](https://github.com/zhenyuwei99/Lammps_Toolbox/blob/master/Data_Analysis/LammpsDataMSD.m)

**LammpsDataMSD** function is used to calculate Mean Square Displacement (MSD).

### [LammpsDataDiffusion(data,alpha)](https://github.com/zhenyuwei99/Lammps_Toolbox/blob/master/Data_Analysis/LammpsDataDiffusion.m)

**LammpsDataDiffusion** function is used to calculate diffusion coefficients

- alpha is ratio of simulation time to maximum MSD interval.

### [LammpsDataRDF(data_01,data_02,r_cut,num_bins)](https://github.com/zhenyuwei99/Lammps_Toolbox/blob/master/Data_Analysis/LammpsDataRDF.m)

**LammpsDataRDF** function is used to calculate Radial Distribution Function (RDF).

- data_01 and data_02 are structure of atom_01, atom_02 generated by **LammpsDataReadDump**, respectively.
- r_cut is the cut off radius in RDF calculation
- num_bins is the number of bins between 0 to r_cut.  

### [LammpsDataPhysicalProp(data,mass)](https://github.com/zhenyuwei99/Lammps_Toolbox/blob/master/Data_Analysis/LammpsDataPhysicalProp.m)

- mass is the mass of atom in data structure

**LammpsDataPhysicalProp** function is used to calculate physical properties in MD simulation.

Current supported properties:
- Momentum
- E_kine
- Temp
- Density

### [LammpsDataCoord2Scl(data)](https://github.com/zhenyuwei99/Lammps_Toolbox/blob/master/Data_Analysis/LammpsDataCoord2Scl.m)

**LammpsDataCoord2Scl** function is used to calculate scaled coordinates from raw coordinates.

### [LammpsDataScl2Coord(data)](https://github.com/zhenyuwei99/Lammps_Toolbox/blob/master/Data_Analysis/LammpsDataScl2Coord.m)

**LammpsDataScl2Coord** function is used to calculate coordinates from scaled coordinates.

### [LammpsDataNeighborList(data,r_cut)](https://github.com/zhenyuwei99/Lammps_Toolbox/blob/master/Data_Analysis/LammpsDataNeighborList.m)

**LammpsDataNeighborList** function is used to construct Neighbor List of each atoms in each dump steps.

- r_cut is the cut off radius for Neighbor List construction.

## Str_Generation

<div  align="center">   
<img src="https://github.com/zhenyuwei99/Lammps_Toolbox/raw/master/Images/README/Github_StrGeneration.png" width = "400" height = "500" alt="Data_Analysis Flowchart" align=center />
</div>   

### [LammpsStrCellCoord(cell_mode,cell_vec)](https://github.com/zhenyuwei99/Lammps_Toolbox/blob/master/Str_Generation/LammpsStrCellCoord.m)

**LammpsStrCellCoord** function is used to generate coordinates of cells. This function should be used before any other manipulations about modeling.

- cell_mode is a char of mode and args of surface.
   - *sin* : rough surface generated by a sin function. args: direction amplitude period
      - direction: direction of function sin. 1 2 3 correspond to x y z respectively.
   - *l* : linear surface
- cell_vec is a 3-D vector represents the # of cell in each direction
   - if **'sin'** is chosen in any direction, # of cells in this direction must be greater than arg **'amplitude'** and cells in direction of sin function should be integral multiples of arg **'period'**.

**Example**
```matlab
cell_mode = ['sin 2 l l'];
cell_vec = [10 10 10];
data_cell = LammpsStrCellCoord(cell_mode,cell_vec);
```

### [LammpsStrCutPore(data_cell,r,dire)](https://github.com/zhenyuwei99/Lammps_Toolbox/blob/master/Str_Generation/LammpsStrCutPore.m)

**LammpsStrCutPore** function is used to generate a pore in the middle of cell unit along axis which is determined by variable **'dire'**.

**Example**
```matlab
data_cell = LammpsStrCutPore(data_cell, 2 , 'z');
```

### [LammpsStrGenerate(data_cell,structure,lattice_const,atom_type,atom_charge) or LammpsStrGenerate(data_cell,structure,pbc)](https://github.com/zhenyuwei99/Lammps_Toolbox/blob/master/Str_Generation/LammpsStrGenerate.m)

**LammpsStrGenerate** is used to generate a structure variable containing all information needed to write a .data file. Two types of command are supported, one for models with specific structure but no specific elements BCC FCC etc, another for models with both specific elements and structure like Si3N4.

- data_cell is a structure which contains information of cells and creates by function **LammpsStrCellCoord**.
- structure is a char (**case insensitive**) of which structure will be used. Supporting list:
    - Type 1: **SC BCC FCC DC**
    - Type 2: **Si3N4 TIP3P SPC**
- Type1:
    - lattice_const is lattice constance of structure.
    - atom_type could be in three types:
       - *Case 1* : atom_type = 1, all atom will be set to type 1;
       - *Case 2* : atom_type = 2, each atom in cell will get an unique type
       - *Case 3* : atom_type is matrix. each of atom will be set to type correspond number in matrix. Matrix length should be equal to # of atoms in cell strictly.
    - atom_charge is the charge of atoms, also obey the rules of atom_type.
       - *Case 1* : atom_charge = 0; All atom charge will be set to 0.
       - *Case 2* : atom_charge single number. All atom will be set to the same charge.
       - *Case 3* : atom_charge is a matrix. Each atom will be set to a charge correspond number in matrix. Same as Case 3 of atom_type, length of matrix should be equal to # of atoms in cell
- Type2
    - pbc: determining which boundary will be applied with PBC condition for bonds definitions.

**Example(1)**
```matlab
% structure = 'bcc';
% cell_mode = ['sin 2 3 5 l l'];
% cell_num = [8,10,5];
% data_cell = LammpsStrCellCoord(cell_mode,cell_num);
% lattice_const = 1;
% atom_type = 1;
% atom_charge = 0;
% data = LammpsStrGenerate(data_cell,structure,,lattice_const,atom_type,atom_charge);
```

**Example(2)**

```matlab
cell_mode = ['l l l'];
cell_num = [4 4 3];
data_cell = LammpsStrCellCoord(cell_mode,cell_num);
data = LammpsStrGenerate(data_cell,'si3n4',['x y']);
```


### [LammpsStrSC](https://github.com/zhenyuwei99/Lammps_Toolbox/blob/master/Str_Generation/LammpsStrSC.m), [LammpsStrBCC](https://github.com/zhenyuwei99/Lammps_Toolbox/blob/master/Str_Generation/LammpsStrBCC.m), [LammpsStrFCC](https://github.com/zhenyuwei99/Lammps_Toolbox/blob/master/Str_Generation/LammpsStrFCC.m), [LammpsStrDC](https://github.com/zhenyuwei99/Lammps_Toolbox/blob/master/Str_Generation/LammpsStrDC.m),[LammpsStrSI3N4](https://github.com/zhenyuwei99/Lammps_Toolbox/blob/master/Str_Generation/LammpsStrSI3N4.m),[LammpsStrTIP3P](https://github.com/zhenyuwei99/Lammps_Toolbox/blob/master/Str_Generation/LammpsStrTIP3P.m)

All above functions will be called by **LammpsStrGenerate** function create structure corresponding to variable **'struture'** in **LammpsStrGenerate**.

### [LammpsStrWrite(data,name_output)](https://github.com/zhenyuwei99/Lammps_Toolbox/blob/master/Str_Generation/LammpsStrWrite.m)

- data is the structure generated by **LammpsStrGenerate**.
- name_output is the name of .data file that you will write.
