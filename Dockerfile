FROM pytorch/pytorch:1.6.0-cuda10.1-cudnn7-devel

COPY . /app
WORKDIR /app


RUN ./run.sh