  PCL_VERSION="1.7.0"
  PCL_DIR="pcl"
  BUILD_DIR="build"
  DEPS_DIR="."
  NUM_PROCESSORS=2

  sudo apt-get install libboost-all-dev -y

  cd $DEPS_DIR

  if [ -d 'pcl-pcl-1.7.0' ]; then
    echo "Removing old version of pcl (pcl-1.7.0) from deps"
    sudo rm -rf pcl-pcl-1.7.0
  fi

  if [ -d 'pcl-pcl-1.7.1' ]; then
    echo "Removing old version of pcl (pcl-1.7.1) from deps"
    sudo rm -rf pcl-pcl-1.7.1
  fi

  if [ ! -d "$PCL_DIR" ]; then
    echo "pcl not found... cloning"
    git clone https://github.com/PointCloudLibrary/pcl.git
    cd $PCL_DIR
    git checkout pcl-$PCL_VERSION
    cd ..
  fi
  
  cd $PCL_DIR
  if [ ! -d "$BUILD_DIR" ]; then
    echo "Existing build of PCL not found.. building from scratch"
    mkdir -p $BUILD_DIR
    cd $BUILD_DIR

    PCL_CMAKE_ARGS="-DCMAKE_BUILD_TYPE=Release -DCMAKE_CXX_FLAGS=-std=c++14"
    if [ -n "$CONTINUOUS_INTEGRATION" ]; then
              # Disable everything unneeded for a faster build
              echo "Installing light build for CI"
              PCL_CMAKE_ARGS="${PCL_CMAKE_ARGS} \
              -DWITH_CUDA=OFF -DWITH_DAVIDSDK=OFF -DWITH_DOCS=OFF \
              -DWITH_DSSDK=OFF -DWITH_ENSENSO=OFF -DWITH_FZAPI=OFF \
              -DWITH_LIBUSB=OFF -DWITH_OPENGL=OFF -DWITH_OPENNI=OFF \
              -DWITH_OPENNI2=OFF -DWITH_QT=OFF -DWITH_RSSDK=OFF \
              -DBUILD_CUDA=OFF -DBUILD_GPU=OFF \
              -DBUILD_tracking=OFF -DBUILD_people=OFF \
              -DBUILD_stereo=OFF -DBUILD_simulation=OFF -DBUILD_apps=OFF \
              -DBUILD_examples=OFF -DBUILD_tools=OFF -DBUILD_visualization=ON"
    fi

    cmake .. ${PCL_CMAKE_ARGS} > /dev/null
    make -j$NUM_PROCESSORS
  fi

  cd $DEPS_DIR/$PCL_DIR/$BUILD_DIR
  sudo make -j$NUM_PROCESSORS install
