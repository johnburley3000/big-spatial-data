# big-spatial-data

Various scripts for generic processing of large spatial datasets in parallel. 

## create_forestcovermap.*
- These scripts convert the Hansen et al. forest cover data into rasters showing binary forest cover for a specific year (2000-2019). 
- Inputs are (1) the 2000 forest cover map, (2) the map of loss year. It could easily also use (3) the gain year, if needed. 

Quick use, after R setup, run it as:

Rscript create_forestcovermap.R --help

Rscript create_forestcovermap.R \
--tile <> \
--threshold <> \
--year <> \
--indir <> \
--outdir <>

To run it in parallel, edit the *.submit script as needed.
