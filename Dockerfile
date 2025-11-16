FROM alpine:latest

RUN echo '@edge https://dl-cdn.alpinelinux.org/alpine/edge/community' >> /etc/apk/repositories && \
    echo '@edge https://dl-cdn.alpinelinux.org/alpine/edge/testing'   >> /etc/apk/repositories && \
    apk -U upgrade && \
    apk -v add tor@edge obfs4proxy@edge curl && \
    rm -rf /var/cache/apk/* && \
    tor --version

# Create /data directory structure
RUN mkdir -p /data/hidden_services && \
    chown -R tor:tor /data && \
    chmod 700 /data/hidden_services

# Copy default torrc to /data
COPY --chown=tor:tor torrc /data/torrc

HEALTHCHECK --timeout=10s --start-period=20s \
    CMD curl --fail -x socks5://localhost:9150 -I -L 'https://www.facebookwkhpilnemxj7asaniu7vnjjbiltxjqhye3mhbshg7kx5tfyd.onion/' || exit 1

USER tor
EXPOSE 8853/udp 9150/tcp
VOLUME /data

CMD ["/usr/bin/tor", "-f", "/data/torrc"]
