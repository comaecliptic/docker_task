FROM ubuntu:18.04
LABEL maintainer="Shamil Urazbakhtin <shamil.urazbakhtin@student.msu.ru>"

ENV SOFT=/soft

RUN apt-get update -y && apt-get install -y \
    make \
    gcc-8 g++-8 \
    libstdc++-8-dev \
    wget \
    pkg-config \
    libncurses5-dev libncursesw5-dev \
    zlib1g-dev \
    libbz2-dev \
    liblzma-dev \
    libcurl4-gnutls-dev

# libdeflate v1.7 (10 Nov 2020)
WORKDIR /tmp
RUN wget https://github.com/ebiggers/libdeflate/archive/v1.7.tar.gz && \
    tar --gzip -xvf v1.7.tar.gz && \
    cd libdeflate-1.7 && \
    make PREFIX=$SOFT/libdeflate && \
    make install

# htslib v1.11 (22 Sep 2020)
RUN wget https://github.com/samtools/htslib/releases/download/1.11/htslib-1.11.tar.bz2 && \
    tar --bzip2 -xvf htslib-1.11.tar.bz2 && \
    cd htslib-1.11 && \
    ./configure --prefix=$SOFT/htslib && \
    make && \
    make install

# samtools v1.11 (22 Sep 2020)
RUN wget https://github.com/samtools/samtools/releases/download/1.11/samtools-1.11.tar.bz2 && \
    tar --bzip2 -xvf samtools-1.11.tar.bz2 && \
    cd samtools-1.11 && \
    ./configure --prefix=$SOFT/samtools && \
    make && \
    make install

# libmaus2 v2.0.770 (23 Jan 2021)
ENV LIBMAUSPREFIX=$SOFT/libmaus2
RUN wget https://gitlab.com/german.tischler/libmaus2/-/archive/2.0.770-release-20210123164625/libmaus2-2.0.770-release-20210123164625.tar.bz2 && \
    tar --bzip2 -xvf libmaus2-2.0.770-release-20210123164625.tar.bz2 && \
    cd libmaus2-2.0.770-release-20210123164625 && \
    ./configure --prefix=$LIBMAUSPREFIX \
        CXX=g++-8 CXXFLAGS=-lstdc++fs && \
    make && \
    make install

# biobambam2 v2.0.179 (28 Dec 2020)
RUN echo $LIBMAUSPREFIX && \
    wget https://gitlab.com/german.tischler/biobambam2/-/archive/2.0.179-release-20201228191456/biobambam2-2.0.179-release-20201228191456.tar.bz2 && \
    tar --bzip2 -xvf biobambam2-2.0.179-release-20201228191456.tar.bz2 && \
    cd biobambam2-2.0.179-release-20201228191456 && \
    ./configure --with-libmaus2=$LIBMAUSPREFIX \
        --prefix=$SOFT/biobambam2 \
        CXX=g++-8 && \
    make install

WORKDIR /
RUN rm -rf /tmp