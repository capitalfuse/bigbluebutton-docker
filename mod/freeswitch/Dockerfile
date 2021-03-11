FROM debian:buster-slim AS builder

# Build from source
RUN apt-get update && \ 
apt-get install -yq --no-install-recommends subversion gnupg2 wget lsb-release ca-certificates iptables nano && \
apt-get clean && rm -rf /var/lib/apt/lists/* && \
wget -O - https://files.freeswitch.org/repo/deb/debian-release/fsstretch-archive-keyring.asc | apt-key add - && \
echo "deb http://files.freeswitch.org/repo/deb/debian-release/ `lsb_release -sc` main" > /etc/apt/sources.list.d/freeswitch.list && \
echo "deb-src http://files.freeswitch.org/repo/deb/debian-release/ `lsb_release -sc` main" >> /etc/apt/sources.list.d/freeswitch.list

# jre installation require man folder
RUN mkdir -p /usr/share/man/man1

RUN apt-get update && \
# Install dependencies required for the build
apt-get -y --no-install-recommends build-dep freeswitch && \
apt-get clean && rm -rf /var/lib/apt/lists/* && \
# then let's get the source. Use the -b flag to get a specific branch
cd /usr/src/ && \
git clone https://github.com/signalwire/freeswitch.git -b v1.10.5 freeswitch && \
cd freeswitch && \
# Because we're in a branch that will go through many rebases, it's
# better to set this one, or you'll get CONFLICTS when pulling (update).
git config pull.rebase true && \
# ... and do the build
./bootstrap.sh -j && \
./configure && \
make && make install && make clean && \
ln -s /usr/local/freeswitch/bin/freeswitch /usr/bin/ && \
ln -s /usr/local/freeswitch/bin/fs_cli /usr/bin && \
# Install audio files:
make sounds-install moh-install && \
cd /usr/src && rm -rf freeswitch && \
# Install Sofia-sip dependencies : https://github.com/freeswitch/sofia-sip
git clone https://github.com/freeswitch/sofia-sip.git -b v1.13.3 sofia-sip && \
cd sofia-sip && \
# Because we're in a branch that will go through many rebases, it's
# better to set this one, or you'll get CONFLICTS when pulling (update).
git config pull.rebase true && \
./bootstrap.sh && \
./configure && \
make && make install && \
cd /usr/src && rm -rf sofia-sip

# install dockerize
#ENV DOCKERIZE_VERSION v0.6.1
#RUN wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
#    && tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
#    && rm dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz

# -- get official bbb freeswitch config
# we use svn for retrieving the files since the repo is quite large,
# git sparse-checkout is not yet available with buster and there
# is no other sane way of downloading a single directory via git
ENV GIT_TAG v2.3-alpha-6
RUN cd /tmp \
    && svn checkout https://github.com/alangecker/bbb-packages/tags/$GIT_TAG/bbb-freeswitch-core/data/opt/freeswitch/etc/freeswitch \
    && cp /tmp/freeswitch/dialplan/default/bbb_* /usr/local/freeswitch/conf/dialplan/default/ \
    && cp /tmp/freeswitch/dialplan/public/bbb_* /usr/local/freeswitch/conf/dialplan/public/ \
    && cp /tmp/freeswitch/directory/default/bbb* /usr/local/freeswitch/conf/directory/default/ \
    && rm -rf /tmp/freeswitch/.svn

# add modifications
COPY ./conf/* /usr/local/freeswitch/conf/


COPY ./entrypoint.sh /entrypoint.sh
ENTRYPOINT /entrypoint.sh
