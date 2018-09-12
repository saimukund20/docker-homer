FROM quay.io/biocontainers/homer
MAINTAINER Chris Miller <c.a.miller@wustl.edu>

LABEL Image for homer on the MGI cluster - uses cmiller-specific annotation directories

#use a softlink so that data gets off of unwritable dirs and points to my annotation directory
rm -rf /usr/local/share/homer-4.9.1-6/data
ln -s /gscmnt/gc6122/cancer-genomics/medseq/annotations/homer/data /usr/local/share/homer-4.9.1-6/data


# needed for MGI data mounts
RUN apt-get update && apt-get install -y libnss-sss && apt-get clean all

#set timezone to CDT
#LSF: Java bug that need to change the /etc/timezone.
#/etc/localtime is not enough.
RUN ln -sf /usr/share/zoneinfo/America/Chicago /etc/localtime && \
    echo "America/Chicago" > /etc/timezone && \
    dpkg-reconfigure --frontend noninteractive tzdata
