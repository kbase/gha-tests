# Base Image
FROM ubuntu:latest

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl \
    default-jdk-headless \
    git \
#    gradle \
    jupyterhub \
    jupyter-notebook \
    python3 \
    python3-pip \
    wget \
    && rm -rf /var/lib/apt/lists/*

# # Install Apache Spark - https://dlcdn.apache.org/spark/spark-3.5.2/spark-3.5.2-bin-hadoop3.tgz
# RUN wget https://dlcdn.apache.org/spark/spark-3.5.2/spark-3.5.2-bin-hadoop3.tgz \
#     && tar xvf spark-3.5.2-bin-hadoop3.tgz -C /opt/ \
#     && rm spark-3.5.2-bin-hadoop3.tgz \
#     && ln -s /opt/spark-3.4.1-bin-hadoop3 /opt/spark

ENV SPARK_HOME=/opt/spark
ENV PATH=$PATH:/opt/spark/bin

#ENV GRADLE_HOME=/opt/gradle
#ENV PATH=$PATH:/opt/gradle/bin
#
## Install JupyterHub
# RUN pip3 install jupyterhub notebook

# Set the entrypoint to JupyterHub
ENTRYPOINT ["jupyterhub"]
