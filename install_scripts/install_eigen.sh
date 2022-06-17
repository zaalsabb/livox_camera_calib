  EIGEN_DIR="eigen-3.4.0"
  BUILD_DIR="build"
  DEPS_DIR="."
  mkdir -p $DEPS_DIR
  cd $DEPS_DIR

  if [ ! -d "$EIGEN_DIR" ]; then
    wget https://gitlab.com/libeigen/eigen/-/archive/3.4.0/eigen-3.4.0.tar.bz2
    tar xjf eigen-3.4.0.tar.bz2
    rm -rf eigen-3.4.0.tar.bz2
  fi

  cd $EIGEN_DIR
  if [ ! -d "$BUILD_DIR" ]; then
    mkdir -p $BUILD_DIR
    cd $BUILD_DIR
    cmake ..
    make
  fi

  cd $DEPS_DIR/$EIGEN_DIR/$BUILD_DIR
  sudo make -j$(nproc) install
