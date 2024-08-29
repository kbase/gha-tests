# Base Image
FROM alpine:latest

# Install dependencies
RUN apk add --no-cache \
    bash \
    curl \
    openjdk8-jre-base \
    git \
    wget

# Install Apache Spark - https://dlcdn.apache.org/spark/spark-3.5.2/spark-3.5.2-bin-hadoop3.tgz
RUN wget https://dlcdn.apache.org/spark/spark-3.5.2/spark-3.5.2-bin-hadoop3.tgz \
    && mkdir -p /opt/spark \
    && tar -xvf spark-3.5.2-bin-hadoop3.tgz -C /opt/spark --strip-components=1 \
    && rm spark-3.5.2-bin-hadoop3.tgz \
    && chmod a+wrx /opt/spark

ENV SPARK_HOME=/opt/spark
ENV PATH=$PATH:$SPARK_HOME/bin:$SPARK_HOME/sbin

# Clean up to reduce image size
RUN rm -rf /var/cache/apk/* /tmp/* /var/tmp/*

# Set up Spark cluster entry point
ENTRYPOINT ["/bin/sh", "-c"]

# Combine the start of master and worker processes
CMD ["/opt/spark/sbin/start-master.sh; /opt/spark/sbin/start-worker.sh spark://$(hostname -f):7077; tail -f /dev/null"]
