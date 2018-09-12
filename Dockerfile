FROM quay.io/biocontainers/homer:4.9.1--pl526h2d50403_6
MAINTAINER Chris Miller <c.a.miller@wustl.edu>

LABEL Image for homer on the MGI cluster - uses cmiller-specific annotation directories

#use a softlink so that data gets off of unwritable dirs and points to my annotation directory
RUN rm -rf /usr/local/share/homer-4.9.1-6/data
RUN ln -s /gscmnt/gc6122/cancer-genomics/medseq/annotations/homer/data /usr/local/share/homer-4.9.1-6/data


# needed for MGI data mounts
RUN apt-get update && apt-get install -y libnss-sss && apt-get clean all

#set timezone to CDT
#LSF: Java bug that need to change the /etc/timezone.
#/etc/localtime is not enough.
RUN ln -sf /usr/share/zoneinfo/America/Chicago /etc/localtime && \
    echo "America/Chicago" > /etc/timezone && \
    dpkg-reconfigure --frontend noninteractive tzdata
