FROM ubuntu:14.04

RUN apt-get update
RUN apt-get install -y dpkg-dev build-essential devscripts lintian diffutils patch patchutils quilt git wget

RUN echo 'deb http://obs.kolabsys.com/repositories/Kontact:/4.13/Ubuntu_14.04/ /' >> /etc/apt/sources.list.d/kolab.list && \
    echo 'deb-src http://obs.kolabsys.com/repositories/Kontact:/4.13/Ubuntu_14.04/ /' >> /etc/apt/sources.list.d/kolab.list && \
    wget http://obs.kolabsys.com/repositories/Kontact:/4.13/Ubuntu_14.04/Release.key && \
    apt-key add Release.key && \
    rm Release.key && \
    apt-get update

RUN apt-get build-dep -y kdepimlibs
RUN mkdir /code && cd /code && apt-get source kdepimlibs

COPY patch /code/patch
RUN cd /code/kdepimlibs-4.13.3+really4.13.0.18/ && patch -p1 < /code/patch

# Build the new package
RUN cd /code/kdepimlibs-4.13.3+really4.13.0.18/ && \
    dch -i "Special release for EyeOS"

RUN cd /code/kdepimlibs-4.13.3+really4.13.0.18/ && \ 
    dpkg-buildpackage -b || true
