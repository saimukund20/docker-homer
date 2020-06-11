FROM bioconductor/bioconductor_docker:devel
MAINTAINER SAI MUKUND <saimukund@wustl.edu>
LABEL Image for homer on the MGI cluster - contains Bioconductor edgeR deseq deseq2

ADD rpackages.R /tmp/
RUN R -f /tmp/rpackages.R

RUN apt-get update && apt-get install -y libnss-sss samtools r-base r-base-dev tabix wget && apt-get clean all

RUN apt-get update && apt-get install -y libnss-sss && apt-get clean all

RUN ln -sf /usr/share/zoneinfo/America/Chicago /etc/localtime && \
    echo "America/Chicago" > /etc/timezone && \
    dpkg-reconfigure --frontend noninteractive tzdata

RUN mkdir /opt/homer/ && cd /opt/homer && wget http://homer.ucsd.edu/homer/configureHomer.pl && /usr/bin/perl configureHomer.pl -install

RUN rm -rf /opt/homer/data

RUN ln -s /gscmnt/gc6122/cancer-genomics/medseq/annotations/homer/data /opt/homer/data

RUN rm -f /opt/homer/config.txt && ln -s /gscmnt/gc6122/cancer-genomics/medseq/annotations/homer/config.txt /opt/homer/config.txt

ENV PATH=${PATH}:/opt/homer/bin/
