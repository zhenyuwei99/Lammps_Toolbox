## Unreleased [0.1.1]

## [0.1.0] -12-31-2019        **:bowtie: Happy New Year!:bowtie:**

### Added

- **LammpsStrTIP3P**
- **LammpsStrSPC**
- **LammpsStrSelectAtom**
- **LammpsStrDeletAtom**
- **LammpsStrSelectCell**
- **LammpsStrDeletCell**
- **LammpsStrMove**
- **LammpsStrCat**

### Changed

- **LammpsCellCoord** won't support 'sin' mode. Only variable 'cell_vec' is needed to call this function. Other features will be complete through **LammpsStrSelectCell** and **LammpsStrDeleteCell** functions.

### Deleted

- **LammpsStrCutPore** will be replaced with **LammpsStrDeleteCell**

## [0.0.9] -12-27-2019

### Changed

- Name of functions in folder **'Data_Analysis'** have all been applied with a prefix **Data**, e.g.: **LammpsRDF -> LammpsDataRDF**
- **LammpsDataReadDump** won't call **readdump_all** function in folder **'Lammps_Internal'**.
- **LammpsStrGenerate**, variables **'cell_mode'** and **'cell_num'** are  removed from parameter table.

### Deleted

- Functions in folder **'Lammps_Internal'** are all been deleted. All functions performed by those functions before have been embedded into left functions.

## [0.0.8] -12-27-2019

### Added

- **LammpsStrSI3N4**
- **LammpsStrCutPore**

### Fixed

- **LammpsStrWrite** now can write information of bonds and masses.

### Changed

- **LammpsStrCellCoord** will be used separately, instead of being called by function **LammpsStrGenerate**, to perform more manipulations on model.

## [0.0.7] -12-05-2019

### Added

- **LammpsStrGenerate**: Roughed surface can be created currently.
- **LammpsStrCellCoord**

### Fixed

- Work flow of structure generation. LammpsStrGenerate will call LammpsStrCellCoord to generate coordinates of cells and then feed this data to functions creating structure corresponding to variable **'struture'** in **LammpsStrGenerate**.

## [0.0.6] -11-30-2019

### Added

- **LammpsReadLog**
- **LammpsScl2Coord**
- **LammpsCoord2Scl**

### Changed

- **LammpsReadDump** will return **'box_size_time'** in output data structure

### Deleted

- **LammpsSclCoord**

### Fixed

- **LammpsRDF**: RDF now converges to 1 when calculating RDF between different atoms.

### Deprecated

- Functions in **Lammps_internal** folder.

## [0.0.5] -11-29-2019

### Added

- **LammpsConstants**
- **LammpsPhysicalProp**: Calculation of **Density** is currently supported.

### Fixed

- **LammpsRDF**:
   - Coordinates should not be unwraped in the beginning of LammpsRDF function. PBC is needed to produce a result that reflects the real condition.
   - New algorithm is applied to calculate RDF, reducing to 1 / 100.


## [0.0.4] -11-28-2019

### Added

- **LammpsNeighborList**
- **LammpsSclCoord**

### Changed

- **LammpsReadDump** will return **'box_volume'** in output data structure

### Fixed

- **LammpsRDF** uses **'data.box_volume'** instead of **'data.box_size' * data.box_size'** as volume of simulation box.

## [0.0.3] -11-27-2019

### Added

- **LammpsPhysicalProp**: Momentum, E_kinetic and Temperature are currently supported.

### Changed

- **LammpsReadDump** can separate data of atoms of different types

## [0.0.2] -11-24-2019

### Added

- **README.md**

### Changed
- Type of input variable atom_type in **LammpsStrGenerate**. Now atom_type could be three case:
   - *Case 1* : atom_type = 1, all atom will be set to type 1;
   - *Case 2* : atom_type = 2, each atom in cell will get an unique type
   - *Case 3* : atom_type is matrix. each of atom will be set to type correspond number in matrix. Matrix length should be equal to # of atoms in cell strictly.

## [0.0.1] -11-23-2019

### Added

- Data_Analysis
   - **LammpsReadDump**
   - **LammpsPBC**
   - **LammpsRDF**
   - **LammpsMSD**
   - **LammpsDiffusion**
- Str_Generation
   - **LammpsStrGenerate**
   - **LammpsStrWrite**
   - **LammpsStrSc**
   - **LammpsStrBCC**
   - **LammpsStrFCC**
   - **LammpsStrDC**
- Lammps_Internal
   - **readdump_all**
   - **readdump_one**
   - **scandump**
