FROM ubuntu:xenial
MAINTAINER Chris Miller <c.a.miller@wustl.edu>

LABEL Image for homer on the MGI cluster - uses cmiller-specific annotation directories

#dependencies
RUN apt-get update && apt-get install -y libnss-sss samtools r-base r-base-dev wget && apt-get clean all

# needed for MGI data mounts
RUN apt-get update && apt-get install -y libnss-sss && apt-get clean all

#set timezone to CDT
#LSF: Java bug that need to change the /etc/timezone.
#/etc/localtime is not enough.
RUN ln -sf /usr/share/zoneinfo/America/Chicago /etc/localtime && \
    echo "America/Chicago" > /etc/timezone && \
    dpkg-reconfigure --frontend noninteractive tzdata

ADD rpackages.R /tmp/
RUN R -f /tmp/rpackages.R

## HOMER ##
RUN mkdir /opt/homer/ && cd /opt/homer && wget http://homer.ucsd.edu/homer/configureHomer.pl && /usr/bin/perl configureHomer.pl -install 

ENV PATH="${PATH}:/opt/homer/bin/"

#use a softlink so that data gets off of unwritable dirs and points to my annotation directory
RUN rm -rf /opt/homer/data
RUN ln -s /gscmnt/gc6122/cancer-genomics/medseq/annotations/homer/data /opt/homer/data

