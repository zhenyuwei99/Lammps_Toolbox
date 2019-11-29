## Unreleased [0.0.6]

## [0.0.5] -11-29-2019

### Fixed

- LammpsRDF: 
   - Coordinates should not be unwraped in the begining of LammpsRDF function. PBC is needed to produce a result that reflects the real condition.
   - New algorithm is applied to calculate RDF, reducing to 1 / 100.


## [0.0.4] -11-28-2019

### Added

- LammpsNeighborList
- LammpsSclCoord
- LammpsReadDump will return **'box_volume'** in output data struture

### Fixed

- LammpsRDF uses **'data.box_volume'** instead of **'data.box_size' * data.box_size'** as volume of simulation box.

## [0.0.3] -11-27-2019

### Added
- LammpsPhysicalProp: Momentu, E_kinetic and Temprature are calculated right now.
- LammpsReadDump can seprate data of atoms of different types

## [0.0.2] -11-24-2019

### Added

- README.md

- Type of input variable atom_type in Str_Generation. Now atom_type could be three case: 
   - *Case 1* : atom_type = 1, all atom will be set to type 1;
   - *Case 2* : atom_type = 2, each atom in cell will get anunique type
   - *Case 3* : atom_type is matric. each of atom will be set to type correspond number in matric. Matric lenghth should be equal to # of atoms in cell strickly.

## [0.0.1] -11-23-2019

### Added

- Data_Analysis
   - LammpsReadDump
   - LammpsPBC
   - LammpsRDF
   - LammpsMSD
   - LammpsDiffusion
- Str_Generation
   - LammpsStrGenerate
   - LammpsStrWrite
   - LammpsStrSc
   - LammpsStrBCC
   - LammpsStrFCC
   - LammpsStrDC
- Lammps_Internal
   - readdump_all
   - readdump_one
   - scandump

