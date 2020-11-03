# docker-hands-on

This little repository was made for an Elixir Norway Snakemake and Docker workshop held during week 45 in 2020.

The working Dockerfile has been moved to the `finishedDockerFile` directory for reference because the purpose is to learn how to make the Dockerfile manually.

The workflow runs three rules, one that sorts the (identical) VCF files, one that runs bgzip and one that indexes the gz files with tabix.
