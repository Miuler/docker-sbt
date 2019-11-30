FROM openjdk:11-jdk-slim

ARG SBT_VERSION=1.3.4
ARG USER_HOME_DIR="/root"
ARG SHA=e2dea253e36160710fbcb46f6d1aa3a79751738bd416f2977bf8816d5427cfa7c7c2942e4fb233b5b9dca56c6026353afbdedd7c9647cbecf209eeecd26020ff
ARG BASE_URL=https://sbt-downloads.cdnedge.bluemix.net/releases/v${SBT_VERSION}

RUN apt-get update && \
    apt-get install -y \
      curl procps \
  && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /usr/share/sbt /usr/share/sbt/ref \
  && curl -fsSL -o /tmp/sbt.tgz ${BASE_URL}/sbt-${SBT_VERSION}.tgz \
  && echo "${SHA}  /tmp/sbt.tgz" | sha512sum -c - \
  && tar -xzf /tmp/sbt.tgz -C /usr/share/sbt --strip-components=1 \
  && rm -f /tmp/sbt.tgz \
  && ln -s /usr/share/sbt/bin/sbt /usr/bin/sbt
RUN sbt \
  && sbt --version \
  && mv $USER_HOME_DIR/.ivy2 /usr/share/sbt/ref/ \
  && mv $USER_HOME_DIR/.sbt /usr/share/sbt/ref/ \
#  && mv $USER_HOME_DIR/.cache/coursier/v1 /usr/share/sbt/ref/ \
  && rm -fr project \
            target \
            /usr/share/sbt/ref/.ivy2/.sbt.ivy.lock \
            /usr/share/sbt/ref/.sbt/boot/sbt.boot.lock

ENV SBT_HOME /usr/share/sbt
ENV SBT_CONFIG "$USER_HOME_DIR/.sbt"
ENV IVY_CONFIG "$USER_HOME_DIR/.ivy2"
#ENV COURSIER_CONFIG "$USER_HOME_DIR/.cache/coursier/v1"

COPY sbt-entrypoint.sh /usr/local/bin/sbt-entrypoint.sh

ENTRYPOINT ["/usr/local/bin/sbt-entrypoint.sh"]
CMD ["sbt"]


