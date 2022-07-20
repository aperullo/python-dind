ARG PYTHON_TAG=3.10

FROM python:${PYTHON_TAG}

# Docker
ENV DOCKER_CHANNEL=stable

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

RUN mkdir -p /etc/apt/keyrings
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
RUN echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  $(lsb_release -cs) ${DOCKER_CHANNEL}" | tee /etc/apt/sources.list.d/docker.list > /dev/null

RUN apt-get update 
RUN apt-get install -y --no-install-recommends docker-ce

# Docker Compose
ARG COMPOSE_VERSION=v2.6.1

RUN curl -L https://github.com/docker/compose/releases/download/$COMPOSE_VERSION/docker-compose-Linux-x86_64 > /usr/local/bin/docker-compose
RUN chmod +x /usr/local/bin/docker-compose

# DIND 
ARG DIND_COMMIT=42b1175eda071c0e9121e1d64345928384a93df1
ENV DOCKER_EXTRA_OPTS='--storage-driver=overlay'
RUN curl -fL -o /usr/local/bin/dind "https://raw.githubusercontent.com/moby/moby/${DIND_COMMIT}/hack/dind"
RUN chmod +x /usr/local/bin/dind

# Entrypoints
RUN curl -fL -o /usr/local/bin/dockerd-entrypoint.sh https://raw.githubusercontent.com/docker-library/docker/master/dockerd-entrypoint.sh
RUN chmod +x /usr/local/bin/dockerd-entrypoint.sh

RUN curl -fL -o /usr/local/bin/docker-entrypoint.sh https://raw.githubusercontent.com/docker-library/docker/master/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

VOLUME /var/lib/docker
EXPOSE 2375 2376
ENTRYPOINT ["dockerd-entrypoint.sh"]

