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
RUN apt-get build-dep -y akonadi
RUN mkdir /code && cd /code && apt-get source akonadi

COPY patch /code/patch
RUN cd /code/akonadi-1.12.42.5 && patch -p1 < /code/patch

# Build the new package
#RUN cd /code/akonadi-1.12.42.5 && \
    #dch -i "Special release for EyeOS"

RUN cd /code/akonadi-1.12.42.5 && \
    dpkg-buildpackage -b || true
