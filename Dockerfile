# set author and base 
# need to use fedora 27 until glide is fixed in fedora 28 
# (or we get an alternative glide) 
FROM arm64v8/fedora:27
MAINTAINER David Igou - This is experimental, I don't recommend using this for anything important <igou.david@gmail.com> 
LABEL version="8.0.0"

WORKDIR /build

RUN dnf install -y wget && \
    dnf clean all && \
    wget https://github.com/heketi/heketi/releases/download/v8.0.0/heketi-v8.0.0.linux.arm64.tar.gz && \
    wget https://github.com/heketi/heketi/releases/download/v8.0.0/heketi-client-v8.0.0.linux.arm64.tar.gz && \
    tar xf heketi-v8.0.0.linux.arm64.tar.gz && \ 
    tar xf heketi-client-v8.0.0.linux.arm64.tar.gz && \
    cp heketi/heketi /usr/bin/heketi && \
    cp heketi/heketi-cli /usr/bin/heketi-cli && \
    mkdir /etc/heketi/ && \
    cp heketi/heketi.json /etc/heketi/ && \
    cp heketi-client/share/heketi/kubernetes/heketi-start.sh /usr/bin/heketi-start.sh && \
    rm -rf /build && \
    dnf remove -y wget && \
    dnf autoremove && \
    dnf clean all
VOLUME /etc/heketi
RUN mkdir /var/lib/heketi
VOLUME /var/lib/heketi
# expose port, set user and set entrypoint with config option ENTRYPOINT ["/usr/bin/heketi-start.sh"]
EXPOSE 8080
ENTRYPOINT ["/usr/bin/heketi-start.sh"]
