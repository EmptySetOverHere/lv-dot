FROM ros:noetic-robot

RUN apt-get update && apt-get install -y \
     ros-noetic-vision-msgs \
     ros-noetic-gazebo-ros-pkgs \
     ros-noetic-pcl-ros \
     ros-noetic-tf2-geometry-msgs \
     ros-noetic-rviz \
     python3.8 python3-pip \
     x11-apps libxkbcommon-x11-0 \
     mesa-utils libgl1-mesa-dri libgl1-mesa-glx libglu1-mesa \
     xvfb \
     tigervnc-standalone-server \
     fluxbox


RUN rm -rf /var/lib/apt/lists/* # Clean up apt cache 
RUN curl -sSL http://get.gazebosim.org | sh
RUN pip3 install -U ultralytics==8.3 torch

RUN mkdir -p /root/.vnc
RUN echo '#!/bin/sh' > /root/.vnc/xstartup && \
    echo 'fluxbox &' >> /root/.vnc/xstartup && \
    chmod +x /root/.vnc/xstartup

WORKDIR /usr/src/lv-dot

COPY . .
COPY ./onboard_detector ./src/onboard_detector

RUN . /opt/ros/noetic/setup.sh && catkin_make
RUN . ./devel/setup.sh

RUN echo "source /opt/ros/noetic/setup.bash && source /usr/src/lv-dot/devel/setup.bash" >> /root/.bashrc

ENV QT_X11_NO_MITSHM=1

COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]


# Run the following command as well
#docker run -it --rm -p 5901:5901 --name fyp_container fyp
#docker exec -it fyp_container bash
#rosbag play -l corridor_demo.bag