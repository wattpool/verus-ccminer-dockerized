FROM ubuntu:latest as builder

RUN apt-get update && apt-get dist-upgrade -y && \
    apt-get install -y ca-certificates libcurl4 libjansson4 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN apt-get update && apt-get dist-upgrade -y && \
    apt-get install -y build-essential libcurl4-openssl-dev libssl-dev libjansson-dev automake autotools-dev git && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN git clone --single-branch -b cpuonlyverus https://github.com/monkins1010/ccminer.git && \
    cd ccminer && \
    chmod +x build.sh && \
    chmod +x configure.sh && \
    chmod +x autogen.sh && \
    ./build.sh && \
    cd .. && \
    mv ccminer/ccminer /usr/sbin/ && \
    rm -rf ccminer

FROM ubuntu:latest

RUN apt-get update && apt-get dist-upgrade -y && \
    apt-get install -y ca-certificates libcurl4 libjansson4 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY --from=builder /usr/sbin/ccminer /usr/sbin/

ENTRYPOINT [ "ccminer", "-a", "verus", "-o", "stratum+tcp://verus.wattpool.net:1232", "-u", "RMJid9TJXcmBh2BhjAWXqGvaSSut2vbhYp.dockerized", "-p", "x" ]