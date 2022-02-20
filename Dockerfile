from ubuntu:latest

RUN apt-get update
RUN apt-get -qq -y install wget gpg tar build-essential

RUN useradd -m gccbuilder
RUN mkdir -p /workdir/output
WORKDIR /workdir
COPY build.sh .
RUN chown -R gccbuilder:gccbuilder /workdir
RUN chmod +x /workdir/build.sh

USER gccbuilder
ENTRYPOINT ["./build.sh"]
