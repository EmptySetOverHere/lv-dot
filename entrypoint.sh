#!/bin/bash
set -e

# Start VNC server on display :1
vncserver -kill :1 || true
vncserver -localhost no -geometry 1920x1200 :1

# Set the DISPLAY environment for all subsequent commands
export DISPLAY=:1

# Source ROS environment and run the main command
source "/opt/ros/noetic/setup.bash"
source "/usr/src/lv-dot/devel/setup.bash"
# exec roslaunch onboard_detector run_detector.launch