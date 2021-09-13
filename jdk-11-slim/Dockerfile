FROM openjdk:11-jdk-slim

ARG SBT_VERSION=1.5.5
ARG USER_HOME_DIR="/root"
ARG SHA=c0fcd50cf5c91ed27ad01c5c6a8717b62700c87a50ff9b0e7573b227acb2b3c9
ARG BASE_URL=https://sbt-downloads.cdnedge.bluemix.net/releases/v${SBT_VERSION}

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
RUN sbt \
  && sbt sbtVersion \
  && cp -r $USER_HOME_DIR/.ivy2 /usr/share/sbt/ref/ \
  && cp -r $USER_HOME_DIR/.sbt /usr/share/sbt/ref/ \
  && cp -r $USER_HOME_DIR/.cache/coursier/v1 /usr/share/sbt/ref/ \
  && rm -fr project \
            target \
            /usr/share/sbt/ref/.ivy2/.sbt.ivy.lock \
            /usr/share/sbt/ref/.sbt/boot/sbt.boot.lock

ENV SBT_HOME /usr/share/sbt
ENV SBT_CONFIG "$USER_HOME_DIR/.sbt"
ENV IVY_CONFIG "$USER_HOME_DIR/.ivy2"
ENV COURSIER_CONFIG "$USER_HOME_DIR/.cache/coursier/v1"

COPY sbt-entrypoint.sh /usr/local/bin/sbt-entrypoint.sh

ENTRYPOINT ["/usr/local/bin/sbt-entrypoint.sh"]
CMD ["sbt"]


