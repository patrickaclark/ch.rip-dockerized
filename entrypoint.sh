#!/bin/bash
set -e

echo "Starting Xvfb on display ${DISPLAY}..."
Xvfb ${DISPLAY} -screen 0 ${SCREEN_WIDTH}x${SCREEN_HEIGHT}x${SCREEN_DEPTH} &
sleep 1

echo "Starting Openbox window manager..."
DISPLAY=${DISPLAY} openbox-session &
sleep 1

echo "Starting x11vnc..."
if [ -n "$VNC_PASSWORD" ]; then
    x11vnc -display ${DISPLAY} -forever -shared -rfbauth <(x11vnc -storepasswd "$VNC_PASSWORD" /tmp/vncpass && echo /tmp/vncpass) &
else
    x11vnc -display ${DISPLAY} -forever -shared -nopw &
fi
sleep 1

echo "Starting noVNC on port 6080..."
websockify --web=/usr/share/novnc/ 6080 localhost:5900 &
sleep 1

echo "Starting ch.rip..."
echo ""
echo "========================================="
echo "  Open http://localhost:6080/vnc.html"
echo "  to interact with the browser"
echo "========================================="
echo ""

# Change to output directory so downloads land there
cd /output

DISPLAY=${DISPLAY} node /app/chrip.js
