# Stage 1: Builder
FROM ubuntu:noble as builder

# Install dependencies for building
RUN apt-get update && apt-get install --no-install-recommends -y \
    curl \
    wget \
    git \
    openjdk-8-jdk-headless \
    && rm -rf /var/lib/apt/lists/*

# Install Apache Spark
RUN wget https://dlcdn.apache.org/spark/spark-3.5.2/spark-3.5.2-bin-hadoop3.tgz \
    && mkdir -p /opt/spark \
    && tar -xvf spark-3.5.2-bin-hadoop3.tgz -C /opt/spark --strip-components=1 \
    && rm spark-3.5.2-bin-hadoop3.tgz \
    && chmod a+wrx /opt/spark

# Stage 2: Runtime
FROM ubuntu:noble

# Install runtime dependencies
RUN apt-get update && apt-get install --no-install-recommends -y \
    openjdk-8-jre-headless \
    && rm -rf /var/lib/apt/lists/*

# Copy Spark from the builder stage
COPY --from=builder /opt/spark /opt/spark

ENV SPARK_HOME=/opt/spark
ENV PATH=$PATH:$SPARK_HOME/bin:$SPARK_HOME/sbin

# Set up Spark cluster entry point
ENTRYPOINT ["/bin/bash", "-c"]

# Combine the start of master and worker processes
CMD ["/opt/spark/sbin/start-master.sh; /opt/spark/sbin/start-worker.sh spark://$(hostname -f):7077; tail -f /dev/null"]
