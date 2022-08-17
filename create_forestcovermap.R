# RCode/create_forestcovermap.R

# J Burley
# Aug 16 2022

## Purpose:
# Use Hansen et al global forest cover data to generate map of forest cover in a given year. 
# Run in parallel over tiles. 

## Run as:
# Rscript create_forestcovermap.R --tile <> --threshold <> --year <> --indir <> --outdir <>

library(optparse)
library(raster)
library(rgdal)

option_list = list(
    make_option(c("-t", "--tile"), type="character", default=NULL,
              help="Unique tile identifier (i.e. coordinates)", metavar="character"),
    make_option(c("-r", "--threshold"), type="numeric", default=NULL,
              help="Perc. forest cover required to call it forest", metavar="numeric"),
    make_option(c("-y", "--year"), type="numeric", default=NULL,
              help="The year of interest", metavar="numeric"),
    make_option(c("-i", "--indir"), type="character", default=NULL,
              help="Location of input data (e.g. /lrs...)", metavar="character"),
    make_option(c("-o", "--outdir"), type="character", default=NULL,
              help="Where to save the new tifs", metavar="character")          
);

opt_parser = OptionParser(option_list=option_list);
opt = parse_args(opt_parser);

start <-  Sys.time()

message("Reading files:")
message(paste0(opt$indir,"TREECOVER/Hansen_GFC-2019-v1.7_treecover2000_",opt$tile,".tif"))
message(paste0(opt$indir,"LOSS/Hansen_GFC-2019-v1.7_lossyear_",opt$tile,".tif"))

message("Options specified:")
message(opt)

## Read rasters for tile t:
base <- raster(paste0(opt$indir,"TREECOVER/Hansen_GFC-2019-v1.7_treecover2000_",opt$tile,".tif"))
loss <- raster(paste0(opt$indir,"LOSS/Hansen_GFC-2019-v1.7_lossyear_",opt$tile,".tif"))

message("Loaded data for tile: ", opt$tile)

## Make the 2000 base level binary, depending on the threshold chosen
## 0: % tree cover < threshold ("not forest")
## 1: % tree cover > threshold ("forest")

message("Making the base layer binary")
base[base < opt$threshold] <- 0
base[base >= opt$threshold] <- 1
message("Time: ", Sys.time() - start)
gc()

## Make the lossyear map binary, depending on the year of interest. (note that they used 10% tree cover to define forest)
## loss of forest = 1
## no loss of forest = 0. 

message("Making the Loss layer binary")
loss[(loss >= 1) & (loss < (opt$year+1) )] <- 1
loss[loss >= (opt$year+1) ] <- 0 
message("Time: ", Sys.time() - start)
gc()

## Subtract the layers to get forest cover in the year of interest

message("Subtracting Loss from base")
#forestcover <- base - loss
forestcover <- overlay(base, loss, fun=function(x,y){return(x-y)})
message("Time: ", Sys.time() - start)
gc()

## Save the new raster tile
message("Writing raster")
writeRaster(forestcover, paste0(opt$outdir, "Hansen_GFC-2019-v1.7_", opt$tile, "_", opt$year, ".tif"))
message("Finished writing new raster for tile: ", opt$tile)
message(Sys.time() - start)

