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

### [LammpsStrCellCoord(cell_vec)](https://github.com/zhenyuwei99/Lammps_Toolbox/blob/master/Str_Generation/LammpsStrCellCoord.m)

**LammpsStrCellCoord** function is used to generate coordinates of cells. This function should be used before any other manipulations about modeling.

- cell_vec is a 3-D vector represents the # of cells in each direction

**Example**
```matlab
cell_vec = [10 10 10];
data_cell = LammpsStrCellCoord(cell_vec);
```

### [LammpsStrSelectCell(data_cell,select_mode,select_arg)](https://github.com/zhenyuwei99/Lammps_Toolbox/blob/master/Str_Generation/LammpsStrSelectCell.m)

**LammpsStrSelectCell** function is used to choose a specific range of cells and generate a structure containing all the information of those cells for further manipulations;

- data_cell is a structure generated by function **LammpsStrCellCoord**
- select_mode is a string determining which kind of region will be selected. Currently supported mode: 'cylinder'.
- select_arg is a string containing all args that needed to determining the region chosen before.
    - cylinder: # of args: 2. (1) radius of cylinder; (2) direction of axis of cylinder.

**Example**
```matlab
% Assuming data_cell has been generated before
select_mode = 'cylinder';
select_arg = '2 z'
data_cell_selected = LammpsStrSelectCell(data_cell,select_mode,select_arg);
```

### [LammpsStrDeleteCell(data_cell,data_cell_selected)](https://github.com/zhenyuwei99/Lammps_Toolbox/blob/master/Str_Generation/LammpsStrDeleteCell.m)

**LammpsStrDeleteCell** function is used to deleted cell points in 'data_cell' determining by 'data_cell_selected' and will return a structure which have exactly the same formation as 'data_cell'.

- data_cell: structure generated by function **LammpsStrCellCoord**
- data_cell_selected: structure generated by function **LammpsStrSelectCell**

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
structure = 'bcc';
cell_vec = [8,10,5];
data_cell = LammpsStrCellCoord(cell_vec);
lattice_const = 1;
atom_type = 1;
atom_charge = 0;
data = LammpsStrGenerate(data_cell,structure,lattice_const,atom_type,atom_charge);
```

**Example(2)**

```matlab
structure = 'si3n4';
cell_vec = [4 4 3];
data_cell = LammpsStrCellCoord(structure,cell_vec);
data = LammpsStrGenerate(data_cell,structure,['x y']);
```

### [LammpsStrSC](https://github.com/zhenyuwei99/Lammps_Toolbox/blob/master/Str_Generation/LammpsStrSC.m), [LammpsStrBCC](https://github.com/zhenyuwei99/Lammps_Toolbox/blob/master/Str_Generation/LammpsStrBCC.m), [LammpsStrFCC](https://github.com/zhenyuwei99/Lammps_Toolbox/blob/master/Str_Generation/LammpsStrFCC.m), [LammpsStrDC](https://github.com/zhenyuwei99/Lammps_Toolbox/blob/master/Str_Generation/LammpsStrDC.m),[LammpsStrSI3N4](https://github.com/zhenyuwei99/Lammps_Toolbox/blob/master/Str_Generation/LammpsStrSI3N4.m),[LammpsStrTIP3P](https://github.com/zhenyuwei99/Lammps_Toolbox/blob/master/Str_Generation/LammpsStrTIP3P.m),[LammpsStrSPC](https://github.com/zhenyuwei99/Lammps_Toolbox/blob/master/Str_Generation/LammpsStrSPC.m)

All above functions will be called by **LammpsStrGenerate** function to create structure 'data' corresponding to variable **'struture'** in **LammpsStrGenerate**.

### [LammpsStrSelectAtom(data,select_mode,select_arg)](https://github.com/zhenyuwei99/Lammps_Toolbox/blob/master/Str_Generation/LammpsStrSelectAtom.m)

**LammpsStrSelectAtom** function is used choose a specific range of atoms and generate a structure containing all the information of those atoms for further manipulations;

- data: structure generated by function **LammpsStrGenerate**
- select_mode is a string determining which kind of region will be selected. Currently supported mode: 'cylinder'.
- select_arg is a string containing all args that needed to determining the region chosen before.
    - cylinder: # of args: 2. (1) radius of cylinder; (2) direction of axis of cylinder.

**Example**
```matlab
% Assuming data has been generated before
select_mode = 'cylinder';
select_arg = '2 z'
data_atom_selected = LammpsStrSelectAtom(data,select_mode,select_arg);
```

### [LammpsStrDeleteAtom(data,data_atom_selected)](https://github.com/zhenyuwei99/Lammps_Toolbox/blob/master/Str_Generation/LammpsStrDeleteAtom.m)

**LammpsStrDeleteCell** function is used to deleted atom points in 'data' determining by 'data_atom_selected' and will return a structure which have exactly the same formation as 'data', could be used in **LammpsStrWrite**.

- data: structure generated by function **LammpsStrGenerate**
- data_atom_selected: structure generated by function **LammpsStrSelectAtom**

### [LammpsStrMove(data,move_vec)](https://github.com/zhenyuwei99/Lammps_Toolbox/blob/master/Str_Generation/LammpsStrMove.m)

**LammpsStrMove** function is used to move both the box and atoms uniformly with a 3-d vector.

- data: structure generated by function **LammpsStrGenerate**
- move_vec: a 3-d vector determing a uniform movements of box and atoms coordinates.

**Example**
```matlab
% Assuming data has been generated before
move_vec = [3 3 3];
data = LammpsStrMove(data,move_vec);
```

### [LammpsStrCat(data01,data02,...)](https://github.com/zhenyuwei99/Lammps_Toolbox/blob/master/Str_Generation/LammpsStrCat.m)

**LammpsStrCat** function is used to concatenate different 'data' structure generated by **LammpsStrGenerate** and a structure containing all information needed to write '.data' file will be returned.

**Example**
```matlab
data_cell_si3n4     = LammpsStrCellCoord([6 5 3]);
data_cell_wat       = LammpsStrCellCoord([10 9 10]);

data_si3n4          = LammpsStrGenerate(data_cell_si3n4,'si3n4','x y');
data_si3n4_selected = LammpsStrSelectAtom(data_si3n4,'cylinder','5 z');
data_si3n4          = LammpsStrDeleteAtom(data_si3n4,data_si3n4_selected);

data_wat_up         = LammpsStrGenerate(data_cell_wat,'tip3p');
data_wat_up         = LammpsStrMove(data_wat_up,[15 4 9]);

data_wat_low        = LammpsStrGenerate(data_cell_wat,'tip3p');
data_wat_low        = LammpsStrMove(data_wat_low,[15 4 -2]);

data_sum            = LammpsStrCat(data_si3n4,data_wat_up,data_wat_low);

LammpsStrWrite(data_sum,'test.data');
```



### [LammpsStrWrite(data,name_output)](https://github.com/zhenyuwei99/Lammps_Toolbox/blob/master/Str_Generation/LammpsStrWrite.m)

- data is the structure generated by **LammpsStrGenerate**.
- name_output is the name of .data file that you will write.
**Example**
```matlab
% Assuming data has been generated before
name_output = 'test.dump';
LammpsStrWrite(data,name_output);
```
