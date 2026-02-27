# ch.rip - Dockerized with noVNC for browser-based interaction
FROM ubuntu:22.04

# Prevent interactive prompts during package install
ENV DEBIAN_FRONTEND=noninteractive

# Install system dependencies
RUN apt-get update && apt-get install -y \
    # Virtual display
    xvfb \
    # VNC server
    x11vnc \
    # Lightweight window manager
    openbox \
    # noVNC dependencies
    novnc \
    websockify \
    # Node.js via nodesource
    curl \
    # ffmpeg for repack.js
    ffmpeg \
    # Misc utilities
    wget \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Install Node.js 20
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy package files and install dependencies first (layer caching)
COPY package*.json ./
RUN npm install

# Copy application files
COPY chrip.js repack.js ./

# Copy the Chrome extension (required - not available via npm)
COPY ext/ ./ext/

# Output directory - mount your audiobook library here
# e.g. docker run -v /your/audiobooks:/output ...
RUN mkdir -p /output

# VNC password (optional, set to empty for no auth)
ENV VNC_PASSWORD=""

# Display settings
ENV DISPLAY=:1
ENV SCREEN_WIDTH=1280
ENV SCREEN_HEIGHT=800
ENV SCREEN_DEPTH=24

# noVNC port
EXPOSE 6080

# Copy and set entrypoint
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]