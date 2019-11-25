## Unreleased [0.0.3]

### Added
- LammpsStrGraphene2D
- LammpsPhysicalProp

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

