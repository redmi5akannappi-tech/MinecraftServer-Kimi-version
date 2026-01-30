FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive \
    LD_LIBRARY_PATH=/app/bedrock \
    HOME=/app \
    PYTHONUNBUFFERED=1

WORKDIR /app

# Install dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    unzip \
    supervisor \
    python3 \
    libcurl4 \
    libssl3 \
    && rm -rf /var/lib/apt/lists/*

# Fix Playit download: Verify binary and make executable
RUN curl -fsSL -o /usr/local/bin/playit https://playit.gg/downloads/playit-linux-amd64 \
    && chmod +x /usr/local/bin/playit \
    && file /usr/local/bin/playit | grep -q "ELF.*x86-64" || (echo "Download failed" && exit 1)

# Setup Bedrock
COPY bedrock-server.zip /tmp/bedrock-server.zip
RUN unzip -q /tmp/bedrock-server.zip -d /app/bedrock \
    && rm /tmp/bedrock-server.zip \
    && chmod +x /app/bedrock/bedrock_server \
    && echo "eula=true" > /app/bedrock/eula.txt

# Copy configs (NOTE: renamed healthcheck.py)
COPY server.properties /app/bedrock/server.properties
COPY healthcheck.py /app/healthcheck.py
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

EXPOSE 10000 19132/udp

CMD ["/usr/bin/supervisord", "-n"]