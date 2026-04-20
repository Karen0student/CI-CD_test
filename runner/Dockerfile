FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt install -y \
    curl jq git sudo ca-certificates software-properties-common \
    && rm -rf /var/lib/apt/lists/* ;

RUN add-apt-repository -y ppa:apptainer/ppa && apt install -y apptainer

# create runner user
RUN useradd -m runner
WORKDIR /home/runner

# install GitHub Actions runner
RUN curl -L -o actions-runner.tar.gz \
    https://github.com/actions/runner/releases/download/v2.333.1/actions-runner-linux-x64-2.333.1.tar.gz \
 && tar xzf actions-runner.tar.gz \
 && rm actions-runner.tar.gz

# copy entrypoint
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

USER runner
ENTRYPOINT ["/entrypoint.sh"]