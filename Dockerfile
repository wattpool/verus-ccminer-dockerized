FROM debian:sid-slim as builder

RUN apt-get update && apt-get dist-upgrade -y && \
    apt-get install -y ca-certificates libcurl4 libjansson4 libgomp1 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN apt-get update && apt-get dist-upgrade -y && \
    apt-get install -y build-essential libcurl4-openssl-dev libssl-dev libjansson-dev automake autotools-dev git && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN git clone --single-branch -b Verus2.2 https://github.com/monkins1010/ccminer.git && \
    cd ccminer && \
    chmod +x build.sh configure.sh autogen.sh && \
    ./build.sh && \
    cd .. && \
    mv ccminer/ccminer /usr/local/bin/ && \
    rm -rf ccminer

FROM debian:sid-slim

RUN apt-get update && apt-get dist-upgrade -y && \
    apt-get install -y ca-certificates libcurl4 libjansson4 libgomp1 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY --from=builder /usr/local/bin/ccminer /usr/local/bin/

ENTRYPOINT [ "ccminer" ]
CMD [ "-a", "verus", "-o", "stratum+tcp://verus.wattpool.net:1232", "-u", "RMJid9TJXcmBh2BhjAWXqGvaSSut2vbhYp.dockerized", "-p", "x", "-tx" ]
