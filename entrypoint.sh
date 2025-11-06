#!/bin/bash
set -e

# Ensure VNC password exists (non-interactive)
mkdir -p /root/.vnc
if [ ! -f /root/.vnc/passwd ]; then
  PASS="${VNC_PASSWORD:-vncpassword}"
  echo "$PASS" | vncpasswd -f > /root/.vnc/passwd
  chmod 600 /root/.vnc/passwd
fi

# Restart VNC server with desired geometry
vncserver -kill :1 || true
VNC_GEOMETRY="${VNC_GEOMETRY:-1920x1200}"
# Force classic VNC auth and fixed port (more compatible with macOS Screen Sharing)
vncserver -localhost no -SecurityTypes VncAuth -geometry "$VNC_GEOMETRY" -rfbport 5901 :1
trap "vncserver -kill :1 || true" EXIT

export DISPLAY=:1
export QT_X11_NO_MITSHM=1

# Source ROS and optional overlays
source "/opt/ros/noetic/setup.bash"
if [ -f "/usr/src/lv-dot/devel/setup.bash" ]; then
  source "/usr/src/lv-dot/devel/setup.bash"
elif [ -f "/usr/src/lv-dot/install/setup.bash" ]; then
  source "/usr/src/lv-dot/install/setup.bash"
else
  echo "Note: No catkin overlay found at /usr/src/lv-dot/devel or /usr/src/lv-dot/install"
fi

# Run command or keep shell open
if [ $# -gt 0 ]; then
  exec "$@"
else
  exec bash
fi