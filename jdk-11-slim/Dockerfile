FROM openjdk:11-jdk-slim

ARG SBT_VERSION=1.3.5
ARG USER_HOME_DIR="/root"
ARG SHA=435b4dd845945e12ca89b84d22e0840e7eb3c4f632e919c084b82288e98c8398660cb8b1bb1b4d7ec1574487def4d572b25dfa4d6ff24a51709454ded817815f
ARG BASE_URL=https://sbt-downloads.cdnedge.bluemix.net/releases/v${SBT_VERSION}

RUN apt-get update && \
    apt-get install -y \
      git curl procps \
  && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /usr/share/sbt /usr/share/sbt/ref \
  && curl -fsSL -o /tmp/sbt.tgz ${BASE_URL}/sbt-${SBT_VERSION}.tgz \
  && echo "${SHA}  /tmp/sbt.tgz" | sha512sum -c - \
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


