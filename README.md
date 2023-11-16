# KG-pipeline

## Authors
Grzegorz Zbrzeżny, Tomasz Siudalski

## Description
KG-pipeline is created to generate a comprehensive knowledge graph from CS documents within two specific archives, 
namely SCPE and CSIS. However, this list may be extended if someone wishes to implement a scraper compatible with 
a different archive and integrate it with our scraper module. Our system relies on the utilization of Docker containers, 
each specifically designed to execute a distinct data processing step. These containers are orchestrated seamlessly through 
a single shell file that is stored within this repository. Solution consists of the following components:
1. [Publication scraper](https://github.com/OpenCS-ontology/publication-scraper)
2. [Section and bibliography extractor](https://github.com/OpenCS-ontology/section-and-bibliography-ie)
3. [Table and figure extractor](https://github.com/OpenCS-ontology/table-and-figure-ie)
4. [Publication embedder](https://github.com/OpenCS-ontology/publication-embeddings)
5. [Topical classifier](https://github.com/OpenCS-ontology/topical-classifier-elastic)
6. [Publication recommender](https://github.com/OpenCS-ontology/publication-recommender)

## Requirements
Solution requires running Docker, we recommend downloading [Docker Desktop](https://docs.docker.com/desktop/)

## Instalation
1. Set your working directory to the location where you want to download this repository.
3. run `git clone https://github.com/OpenCS-ontology/kg-pipeline`

## Usage
1. Make sure your working directory is set to `kg-pipeline` repository folder
2. Make sure Docker Desktop is running (if you are on Windows we recommend using [WSL](https://learn.microsoft.com/en-us/windows/wsl/install))
3. run `bash ./run_project.sh  csis_volumes=volume_numbers scpe_issues=issue_numbers`, where:
   
   - `volume_numbers` is a string consisting of CSIS archive volumes you want to process in a form of numbers separated by commas (e.g. "1,2,3") 
   - `issue_numbers` is a string consisting of SCPE archive issues you want to process in a form of numbers separated by commas (e.g. "1,2,3")

