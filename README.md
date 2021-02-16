# Docker image to use samtools and biobambam2

# Installed libraries
- libdeflate v1.7
- htslib v1.11
- samtools v1.11
- libmaus2 v2.0.770
- biobambam2 v2.0.179

# Usage
```
# build docker image
docker build -t <image_name>:<image_tag> <path/to/Dockerfile/folder>

# run image interactively
docker run --rm -it <image_name>
```