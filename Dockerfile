FROM ros:kinetic

# update
RUN apt-get -y update
RUN apt-get -y install git
RUN apt-get -y install wget

# install cv and pcl tools for ros
RUN apt-get install ros-kinetic-cv-bridge ros-kinetic-pcl-conversions -y

# copy and run install scripts for ceres, eigen, and pcl
RUN mkdir $HOME/software
WORKDIR $HOME/software

COPY install_scripts install_scripts

RUN chmod +x install_scripts/install_ceres.sh
RUN chmod +x install_scripts/install_eigen.sh
#RUN chmod +x install_scripts/install_pcl.sh

RUN apt-get install libpcl-dev -y

RUN ./install_scripts/install_ceres.sh && cd $HOME/software
RUN ./install_scripts/install_eigen.sh && cd $HOME/software
#RUN ./install_scripts/install_pcl.sh && cd $HOME/software

# clone ros package repo
ENV ROS_WS $HOME/catkin_ws
RUN mkdir -p $ROS_WS/src
WORKDIR $ROS_WS
RUN git -C src clone https://github.com/zaalsabb/livox_camera_calib.git

# install build tools
RUN apt-get update && apt-get install -y \
      python-catkin-tools \
      git \
    && rm -rf /var/lib/apt/lists/*

# install pcl ros
RUN apt-get update
RUN apt-get install ros-kinetic-pcl-ros -y

# build ros package source
RUN catkin config \
      --extend /opt/ros/$ROS_DISTRO && \
    catkin build \
      livox_camera_calib

# HTTP PORT
EXPOSE 80

# setup ros environment
RUN echo "source /opt/ros/kinetic/setup.bash" >> ~/.bashrc
RUN echo "source $ROS_WS/devel/setup.bash" >> ~/.bashrc