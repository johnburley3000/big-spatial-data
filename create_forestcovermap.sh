#!/bin/bash
#SBATCH -J FC_map
#SBATCH -t 6:00:00
#SBATCH -c 1
#SBATCH --mem=40g
#SBATCH -o Logs/fc_map-%j.out
#SBATCH -e Logs/fc_map-%j.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=john_burley@brown.edu

# Shouldn't take more than 1.5 hrs per tile. 
# Should run with ~ 25-30 GB for most tiles. 

cd /users/jburley/scratch/YTDscratch
LAB=/users/jburley/data/jburley/TreeDetectionTracking/Amazon2016flowering

# Run it as:
# sbatch Code/create_forestcovermap.sh <tile> <threshold> <year> <indir> <outdir>
# Good idea to loop through a set of tiles when submitting through sbatch... 

# For descriptions of input:
# Rscript RCode/create_forestcovermap.R --help

source /gpfs/home/jburley/ccv_modules 
# equiv.:
# module load  R/4.0.0 udunits/2.2.24 gcc/8.3 pcre2/10.35 geos/3.8.1 gdal/3.0.4 proj/7.0.0

Rscript ${LAB}/Code/create_forestcovermap.R \
-t $1 \
-r $2 \
-y $3 \
-i $4 \
-o $5

# If merging rasters is desired after processing, probably best to use merge_gdal.py (https://gdal.org/programs/gdal_merge.html)
