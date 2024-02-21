FROM ubuntu:focal

# Install the base set of packages
RUN apt-get update; apt-get -y upgrade;\
    apt-get install -y python3 python3-pip;\
    rm -rf /tmp/*
RUN apt-get -y install apt-utils git
RUN apt-get -y install curl
RUN apt-get -y install rsync

# Create all the links needed
RUN rm /usr/bin/pip && ln -s /usr/bin/python3 /usr/bin/python && \
    ln -s /usr/bin/pip3 /usr/bin/pip
RUN pip install xml2rfc xym codespell

RUN mkdir /git
# Tools to build yanger
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get -y install erlang libxml2-dev
RUN cd /git && git clone https://github.com/mbj4668/yanger.git
RUN cd /git/yanger; source env.sh; make
ENV PATH $PATH:/git/yanger/bin/

# Tools to build pyang
RUN cd /git && git clone https://github.com/mbj4668/pyang.git
RUN cd /git/pyang; source env.sh; make
ENV PATH $PATH:/git/pyang/bin/

# Add rfcfold
RUN cd /git && git clone https://github.com/ietf-tools/rfcfold.git
ENV PATH $PATH:/git/rfcfold

# Add idnits
RUN cd /git && git clone https://github.com/ietf-tools/idnits.git
ENV PATH $PATH:/git/idnits

# Tools to build yanglint
RUN apt-get -y install cmake
RUN apt-get -y install libpcre2-dev
RUN cd /git && git clone -b devel https://github.com/CESNET/libyang.git
RUN cd /git/libyang && mkdir build && cd build && cmake .. && make && make install
RUN ldconfig

# Button up the remaining paths and links
RUN ln -s /usr/bin/sed /usr/bin/gsed

# Remove alternative awk and replace it with GNU awk
RUN apt-get -y install gawk
RUN rm -rf /usr/bin/awk && ln -s /usr/bin/gawk /usr/bin/awk
