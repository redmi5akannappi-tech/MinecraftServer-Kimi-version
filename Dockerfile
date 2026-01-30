FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive \
    LD_LIBRARY_PATH=/app/bedrock \
    HOME=/app

WORKDIR /app

# Minimal runtime (ca-certificates required for Playit HTTPS)
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    unzip \
    supervisor \
    python3 \
    libcurl4 \
    libssl3 \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean

# Install Playit
RUN curl -L https://playit.gg/downloads/playit-linux-amd64 -o /usr/local/bin/playit \
    && chmod +x /usr/local/bin/playit

# Setup Bedrock
COPY bedrock-server.zip /tmp/bedrock-server.zip
RUN unzip -q /tmp/bedrock-server.zip -d /app/bedrock \
    && rm /tmp/bedrock-server.zip \
    && chmod +x /app/bedrock/bedrock_server \
    && echo "eula=true" > /app/bedrock/eula.txt

# Configs
COPY server.properties /app/bedrock/server.properties
COPY http.py /app/http.py
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Playit needs writable config dir for claim token (optional: mount disk here for persistence)
RUN mkdir -p /app/.config/playit && chmod 777 /app/.config/playit

EXPOSE 10000 19132/udp

CMD ["/usr/bin/supervisord", "-n"]