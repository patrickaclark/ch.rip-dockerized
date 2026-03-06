# ch.rip - Dockerized with noVNC for browser-based interaction
FROM ubuntu:22.04

# Prevent interactive prompts during package install
ENV DEBIAN_FRONTEND=noninteractive

# Install Node.js repo first, then install everything in one layer
RUN apt-get update && apt-get install -y curl ca-certificates \
    && curl -fsSL https://deb.nodesource.com/setup_20.x | bash -

RUN apt-get install -y \
    # Virtual display
    xvfb \
    # VNC server
    x11vnc \
    # Lightweight window manager
    openbox \
    # noVNC dependencies
    novnc \
    websockify \
    nodejs \
    ffmpeg \
    wget \
    # Chrome for Testing shared library dependencies
    libglib2.0-0 \
    libnss3 \
    libnspr4 \
    libatk1.0-0 \
    libatk-bridge2.0-0 \
    libcups2 \
    libdrm2 \
    libdbus-1-3 \
    libxcb1 \
    libxkbcommon0 \
    libx11-6 \
    libxcomposite1 \
    libxdamage1 \
    libxext6 \
    libxfixes3 \
    libxrandr2 \
    libgbm1 \
    libpango-1.0-0 \
    libcairo2 \
    libasound2 \
    libatspi2.0-0 \
    fonts-liberation \
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