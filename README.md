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
```flow
st=>start: Start:>https://www.zybuluo.com
io=>inputoutput: verification
op=>operation: Your Operation
cond=>condition: Yes or No?
sub=>subroutine: Your Subroutine
e=>end

st->io->op->cond
cond(yes)->e
cond(no)->sub->io
```


### LammpsReadDump

### LammpsPBC

### LammpsMSD

### LammpsDiffusion

### LammpsRDF
