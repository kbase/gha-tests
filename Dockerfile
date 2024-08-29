# Base Image
FROM ubuntu:noble

# Install dependencies
RUN apt-get update && apt-get install --no-install-recommends -y \
    curl \
    default-jre-headless \
    git \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Install Apache Spark - https://dlcdn.apache.org/spark/spark-3.5.2/spark-3.5.2-bin-hadoop3.tgz
RUN wget https://dlcdn.apache.org/spark/spark-3.5.2/spark-3.5.2-bin-hadoop3.tgz \
    && mkdir -p /opt/spark \
    && tar -xvf spark-3.5.2-bin-hadoop3.tgz -C /opt/spark --strip-components=1 \
    && rm spark-3.5.2-bin-hadoop3.tgz \
    && ln -s /opt/spark-3.4.1-bin-hadoop3 /opt/spark \
    && chmod a+wrx /opt/spark

ENV SPARK_HOME=/opt/spark
ENV PATH=$PATH:$SPARK_HOME/bin:$SPARK_HOME/sbin

# Clean up to reduce image size
RUN apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Set up Spark cluster entry point
ENTRYPOINT ["/bin/bash", "-c"]

# Combine the start of master and worker processes
CMD ["/opt/spark/sbin/start-master.sh; /opt/spark/sbin/start-worker.sh spark://$(hostname -f):7077; tail -f /dev/null"]


## Base Image
#FROM ubuntu:noble
#
## Install dependencies
#RUN apt-get update && apt-get install --no-install-recommends -y \
#    curl \
#    default-jre-headless \
#    git \
#    wget \
#    && rm -rf /var/lib/apt/lists/*
#
## Install Apache Spark - https://dlcdn.apache.org/spark/spark-3.5.2/spark-3.5.2-bin-hadoop3.tgz
#RUN wget https://dlcdn.apache.org/spark/spark-3.5.2/spark-3.5.2-bin-hadoop3.tgz \
#    && tar xvf spark-3.5.2-bin-hadoop3.tgz -C /opt/ \
#    && rm spark-3.5.2-bin-hadoop3.tgz \
#    && ln -s /opt/spark-3.4.1-bin-hadoop3 /opt/spark \
#    && chmod a+wrx /opt/spark
#
#ENV SPARK_HOME=/opt/spark
#ENV PATH=$PATH:$SPARK_HOME/bin:$SPARK_HOME/sbin
#
##ENV GRADLE_HOME=/opt/gradle
##ENV PATH=$PATH:/opt/gradle/bin
##
### Install JupyterHub
## RUN pip3 install jupyterhub notebook
#
## Set the entrypoint to JupyterHub
## ENTRYPOINT [""]
#
## Set up Spark cluster entry point
#ENTRYPOINT ["/bin/bash", "-c"]
#
## Combine the start of master and worker processes
#CMD ["/opt/spark/sbin/start-master.sh; /opt/spark/sbin/start-worker.sh spark://$(hostname -f):7077; tail -f /dev/null"]