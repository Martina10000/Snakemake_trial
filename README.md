# Snakefile_trial

## Name
Example of Snakemake usage for a Rmarkdown workflow 

## Description
This is an example of a working Snakefile for a Rmarkdown workflow. It also contains a guide explaining how to install snakemake and use it in this context. 

## Usage
This project serves as an example and is complemented with the guide. So you can either use the guide to setup your own pipeline using RMarkdown and snakefile or you can download the example pipeline and edit it for your needs. 

In case you wnat to run the existing pipeline you will need R (version 4.5.0 ), Python (version 3.13.3), Snakemake (version 9.3.0) and Pandoc (version 3.6.4) installed in your computer or server and the following  R packages with their versions: 
Table: R Packages and Their Versions

|Package              |Version    |
|:--------------------|:----------|
|Seurat               |5.3.0      |
|dplyr                |1.1.4      |
|ggplot2              |3.5.2      |
|Matrix               |1.7.3      |
|stringr              |1.5.1      |
|knitr                |1.50       |
|pryr                 |0.1.6      |
|clustree             |0.5.1      |
|dittoSeq             |1.20.0     |
|SingleCellExperiment |1.30.1     |
|kableExtra           |1.4.0      |
|celldex              |1.18.0     |
|SingleR              |2.10.0     |
|SeuratData           |0.2.2.9002 |
|HGNChelper           |0.8.15     |
|clusterProfiler      |4.16.0     |
|ReactomePA           |1.52.0     |

## Support
If you have any doubts I can be conatcted at msangeniscrusi@gmail.com

## Authors and acknowledgment
The scripts are taken from the Seurat tutorial (https://satijalab.org/seurat/articles/pbmc3k_tutorial.html) the only original work is the implementation into a snakmake pipeline and the merge script for compiling all the resulting reprots (htmls) into one index.  

