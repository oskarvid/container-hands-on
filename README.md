# docker-hands-on

This little repository was made for an Elixir Norway Snakemake and Docker workshop held during week 45 in 2020.

The working Dockerfile has been moved to the `finishedDockerFile` directory for reference because the purpose is to learn how to make the Dockerfile manually.

The workflow runs three rules, one that sorts the (identical) VCF files, one that runs bgzip and one that indexes the gz files with tabix.

# Finding a docker image and running a tool once
1. `docker search samtools`
2. `docker pull samtools`
3. `docker run -ti -v $(pwd):/data -w /data kfdrc/samtools samtools view -H inputs/my-file.bam`
4. `docker run ps -a`
5. `docker container prune`

# Starting a webserver
1. I want to run an rstudio server
2. `docker pull rocker/rstudio:3.2.0`
3. `docker run -d -p 8787:8787 -e PASSWORD=yourpasswordhere --name my-rstudio rocker/rstudio:3.2.0`
4. write `localhost:8787` in your browser to use rstudio
5. Run: `docker exec -ti my-rstudio bash` - Enter a bash shell in a running container
6. Run: `docker inspect my-rstudio` - Detailed information about the container

# Build an image that installs tools using conda
Create a file called `Dockerfile` with these contents:  
```
FROM snakemake/snakemake:latest

RUN conda config --add channels conda-forge
RUN conda config --add channels bioconda

WORKDIR /
COPY dependencies.yaml /
RUN conda create --name env --file dependencies.yaml
RUN echo "source activate env" > ~/.bashrc
ENV PATH /opt/conda/envs/env/bin:$PATH

CMD ["snakemake", "-j", "-p", "-r"]
```

1. Build it: `docker build --rm -t vcfsort .`  
2. Run it: `docker run --rm -ti -v $(pwd):/data -w /data vcfsort`


## Use the docker image to make a singularity image:
If you don't have Singularity installed, follow these instructions: https://github.com/hpcng/singularity/blob/master/INSTALL.md  
If you want a docker account, create one here: https://hub.docker.com/signup  
With an account you can run this:  
`docker push name/vcfsort`

Then run:  
`singularity build singularity/vcfsort.sif docker://oskarv/vcfsort`

## Use the Dockerfile to build the singularity image:
This method works without needing a docker account to be able to push an image to dockerhub first:
1. `sudo ./singularity/advancedBuildMethod.sh`

# Run the workflow with the new singularity image
If you have files from a previous run of the workflow, run this: `sudo ./clean.sh`  
Then run this: `singularity exec -B $(pwd):/data -W /data singularity/vcfsort.sif snakemake -j -p -r`