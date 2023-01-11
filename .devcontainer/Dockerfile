ARG RUBY_VERSION=3.2.0
ARG BUNDLER_VERSION=2.3.25
ARG NODE_VERSION=16.19.0

# Ruby built from source using ruby-build
FROM ubuntu:20.04 AS rubybuild

SHELL ["/bin/bash", "-le", "-c"]

ARG RUBY_VERSION
ARG DEBIAN_FRONTEND=noninteractive
ARG BASE_PACKAGES="\
sudo curl git autoconf bison build-essential \
libssl-dev libyaml-dev libreadline6-dev zlib1g-dev \
libncurses5-dev libffi-dev libgdbm6 libgdbm-dev \
libdb-dev uuid-dev patch rustc libyaml-dev libreadline6-dev \
libgmp-dev\
"
ENV TZ=Europe/Paris

RUN apt-get update && apt-get install -y $BASE_PACKAGES && rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/rbenv/ruby-build.git
WORKDIR ruby-build
RUN ./install.sh
RUN ruby-build $RUBY_VERSION /usr/local

# Final base image
FROM ubuntu:20.04
LABEL maintainer "jwoodrow <james@just-help.me>"

SHELL ["/bin/bash", "-le", "-c"]

ARG BUNDLER_VERSION
ARG NODE_VERSION
ARG DEBIAN_FRONTEND=noninteractive
ARG BASE_PACKAGES="\
python3.9 git curl nodejs npm libssl-dev \
poppler-utils ffmpeg libjemalloc-dev ruby-sinatra \
build-essential dh-autoreconf libpq-dev libv8-dev \
libffi-dev libltdl7 libsdl2-ttf-dev libpng-dev \
ghostscript sassc libsass-dev libltdl-dev libx11-dev \
libzstd-dev libfftw3-dev libfontconfig libfreetype6-dev \
libraqm-dev libgvc6 libheif-dev libjpeg-dev patch rustc \
fonts-dejavu-core gsfonts fonts-urw-base35 libyaml-dev \
libreadline6-dev libgmp-dev libcurl4-openssl-dev \
imagemagick\
"

ENV TZ=Europe/Paris

# Install base depencies
RUN apt-get update && apt-get -y install software-properties-common && rm -rf /var/lib/apt/lists/*
RUN apt-get update && yes | add-apt-repository ppa:deadsnakes/ppa && apt-get -y install $BASE_PACKAGES && rm -rf /var/lib/apt/lists/*

# Install minio client
RUN curl https://dl.min.io/client/mc/release/linux-amd64/mc -o /usr/local/bin/mc
RUN chmod +x /usr/local/bin/mc
COPY scripts/reset_bucket /usr/local/bin/reset_bucket
RUN chmod +x /usr/local/bin/reset_bucket

# Stage : Install node
RUN npm i -g n
RUN n $NODE_VERSION
RUN npm install --location=global npm@latest
RUN npm i -g yarn

# Stage : Install ruby version
COPY --from=rubybuild /usr/local /usr/local

# Never install gems with documentation
RUN echo -e "gem: --no-document\ninstall: --no-document\nupdate: --no-document" > $HOME/.gemrc
RUN gem install bundler -v "$BUNDLER_VERSION"
RUN bundle config --global build.pg --with-opt-dir="/usr/local/opt/libpq"
RUN bundle config --global build.libv8 --with-system-v8
RUN bundle config --global build.libv8-node --with-system-v8

WORKDIR $HOME

ENTRYPOINT ["/bin/bash", "-e", "-c"]

CMD ["echo", '"DONE"']
