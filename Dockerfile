FROM ros:noetic-robot

# Install system and Python dependencies (includes Gazebo11)
RUN apt-get update && apt-get install -y \
     ros-noetic-vision-msgs \
     ros-noetic-rosbag \
     ros-noetic-gazebo-ros-pkgs \
     ros-noetic-pcl-ros \
     ros-noetic-tf2-geometry-msgs \
     ros-noetic-rviz \
     python3.8 python3-pip \
     x11-apps libxkbcommon-x11-0 \
     mesa-utils libgl1-mesa-dri libgl1-mesa-glx libglu1-mesa \
     xvfb \
     tigervnc-standalone-server \
     fluxbox \
     gazebo11 \
  && rm -rf /var/lib/apt/lists/*

# Removed deprecated Gazebo script
# RUN curl -sSL http://get.gazebosim.org | sh

RUN pip3 install -U ultralytics==8.3 torch

# Setup for VNC
RUN mkdir -p /root/.vnc
RUN echo '#!/bin/sh' > /root/.vnc/xstartup && \
    echo 'fluxbox &' >> /root/.vnc/xstartup && \
    chmod +x /root/.vnc/xstartup

WORKDIR /usr/src/lv-dot

COPY . .
RUN echo "source /opt/ros/noetic/setup.bash" >> /root/.bashrc

RUN /bin/bash -c "source /opt/ros/noetic/setup.bash && catkin_make"
ENV QT_X11_NO_MITSHM=1

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]