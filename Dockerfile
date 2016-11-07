FROM debian:jessie

RUN apt-get update && apt-get install -y curl openssh-server

# create user 'user' with password 'ondevice'
RUN adduser --gecos 'demo user' --disabled-password user

# install ondevice
RUN curl -sSL https://repo.ondevice.io/install_deb.sh | bash -e

COPY res/ /
RUN chown user:user /home/user/.config -R

ENTRYPOINT /run.sh
