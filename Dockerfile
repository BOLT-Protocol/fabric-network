FROM ubuntu:latest
WORKDIR /usr/src/fabric-network

COPY . .

ENV PATH="/usr/src/fabric-network/bins/bin:${PATH}"

# CMD ["bash", "start-base.sh"]

CMD ["sh", "-c", "tail -f /dev/null"]