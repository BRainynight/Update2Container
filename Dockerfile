FROM ubuntu:18.04
RUN apt-get install --assume-yes 
RUN apt-get -y update && apt-get -y upgrade 
RUN apt -y update && apt -y upgrade

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get install -y tzdata
RUN ln -fs /usr/share/zoneinfo/America/New_York /etc/localtime
RUN dpkg-reconfigure -f noninteractive tzdata

# Install python 3.8
RUN apt-get install -y curl wget python3.8 python3.8-dev python3.8-distutils
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3.8 1 \
    && update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.8 2 \
    && update-alternatives --set python /usr/bin/python3.8

RUN apt-get install -y git libatlas-base-dev 
RUN curl -s https://bootstrap.pypa.io/get-pip.py -o get-pip.py && \
    python get-pip.py --force-reinstall && \
    rm get-pip.py


WORKDIR ~/Desktop
COPY docker-start.sh docker-start.sh
RUN chmod +x docker-start.sh

ENTRYPOINT ["./docker-start.sh"]
CMD ["python",  "Update2Container/hello.py"]
