FROM openjdk:11-jdk-slim

ARG SBT_VERSION=1.6.1
ARG USER_HOME_DIR="/root"
ARG SHA=60286bf1b875b31e2955f8a699888cd2612e9afd94d03cde0a2e71efd7492ffc
ARG BASE_URL=https://github.com/sbt/sbt/releases/download/v${SBT_VERSION}

#ADD ${BASE_URL}/sbt-${SBT_VERSION}.tgz /tmp/sbt.tgz

RUN apt-get update && \
    apt-get install -y \
      git curl procps \
  && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /usr/share/sbt /usr/share/sbt/ref \
  && curl -fsSL -o /tmp/sbt.tgz ${BASE_URL}/sbt-${SBT_VERSION}.tgz \
  && echo "${SHA}  /tmp/sbt.tgz" | sha256sum -c - \
  && tar -xzf /tmp/sbt.tgz -C /usr/share/sbt --strip-components=1 \
  && rm -f /tmp/sbt.tgz \
  && ln -s /usr/share/sbt/bin/sbt /usr/bin/sbt
RUN sbt -Dsbt.rootdir=true sbtVersion
RUN  cp -r $USER_HOME_DIR/.sbt /usr/share/sbt/ref/ \
  && cp -r $USER_HOME_DIR/.cache/coursier/v1 /usr/share/sbt/ref/ \
  && rm -fr project \
            target \
            /usr/share/sbt/ref/.sbt/boot/sbt.boot.lock

ENV SBT_HOME /usr/share/sbt
ENV SBT_CONFIG "$USER_HOME_DIR/.sbt"
ENV COURSIER_CONFIG "$USER_HOME_DIR/.cache/coursier/v1"

COPY sbt-entrypoint.sh /usr/local/bin/sbt-entrypoint.sh

ENTRYPOINT ["/usr/local/bin/sbt-entrypoint.sh"]
CMD ["sbt"]


