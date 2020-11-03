FROM snakemake/snakemake

RUN conda config --add channels conda-forge
RUN conda config --add channels bioconda

WORKDIR /
COPY dependencies.yaml /
RUN conda create --name env --file dependencies.yaml
RUN echo "source activate env" > ~/.bashrc
ENV PATH /opt/conda/envs/env/bin:$PATH

CMD ["snakemake", "-j", "-p", "-r"]