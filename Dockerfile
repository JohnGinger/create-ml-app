#FROM pytorch/pytorch:1.6.0-cuda10.1-cudnn7-devel

ARG CUDA_VERSION=10.1
ARG CUDNN=7
FROM nvidia/cuda:$CUDA_VERSION-cudnn$CUDNN-devel-ubuntu18.04

RUN apt-get update -qq && apt-get install -y -q \
        build-essential \
        pkg-config \
        software-properties-common \
        curl \
        git \
        unzip \
        zlib1g-dev \
        locales \
    && apt-get clean -qq && rm -rf /var/lib/apt/lists/*

RUN locale-gen en_US.UTF-8
ENV LANG=en_US.UTF-8 LANGUAGE=en_US.en LC_ALL=en_US.UTF-8

ENV PYTHONPATH="${PYTHONPATH}:/src"
ENV PATH=/opt/conda/bin:$PATH
ENV PYTHONVERSION=3.6.9

# conda needs an untainted base environment to function properly
# that's why a new separate conda environment is created
RUN curl "https://repo.anaconda.com/miniconda/Miniconda3-4.7.12.1-Linux-x86_64.sh" --output ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p /opt/conda && \
    rm -rf ~/.cache ~/miniconda.sh

RUN conda install pytorch torchvision cudatoolkit=10.1 -c pytorch

## split the conda installations because the dev boxes have limited memory
#RUN /opt/conda/bin/conda create -n env -c conda-forge python=$PYTHONVERSION pip && \
#    /opt/conda/bin/conda clean -a && \
#    ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
#    echo ". /opt/conda/etc/profile.d/conda.sh" > ~/.env && \
#    echo "conda activate env" >> ~/.env && \
#    echo "source ~/.env" >> ~/.bashrc

#RUN /opt/conda/bin/conda install conda-build \
# && /opt/conda/bin/conda create -y --name py36 python=$PYTHONVERSION \
# && /opt/conda/bin/conda clean -ya
#ENV CONDA_DEFAULT_ENV=py36
#ENV CONDA_PREFIX=/opt/conda/envs/$CONDA_DEFAULT_ENV
#ENV PATH=$CONDA_PREFIX/bin:$PATH

#ENV BASH_ENV=~/.env
#SHELL ["/bin/bash", "-c"]

#RUN pip install poetry
#RUN pip install black
#
#COPY . /app
#WORKDIR /app
#
#RUN poetry install

#
#CMD /bin/bash ./pegasus_run.sh
#
#FROM python:3.7
#RUN pip install black
#COPY ./pegasus_run.sh /
##CMD /bin/bash ./pegasus_run.sh