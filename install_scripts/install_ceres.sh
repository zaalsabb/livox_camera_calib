# Install Dependencies
# CMake
sudo apt-get install cmake -y
# google-glog + gflags
sudo apt-get install libgoogle-glog-dev libgflags-dev -y
# BLAS & LAPACK
sudo apt-get install libatlas-base-dev -y
# Eigen3
sudo apt-get install libeigen3-dev -y
# SuiteSparse and CXSparse (optional)
sudo apt-get install libsuitesparse-dev -y

CERES_DIR="ceres-solver-1.14.0"
BUILD_DIR="build"
DEPS_DIR="."

# this install script is for local machines.
if (find /usr/local/lib -name libceres.so | grep -q /usr/local/lib); then
    echo "Ceres is already installed."
else
	echo "Installing Ceres 1.14.0 ..."
        mkdir -p "$DEPS_DIR"
        cd "$DEPS_DIR"

        if [ ! -d "$CERES_DIR" ]; then
          wget "http://ceres-solver.org/$CERES_DIR.tar.gz"
          tar zxf "$CERES_DIR.tar.gz"
          rm -rf "$CERES_DIR.tar.gz"
        fi

        cd $CERES_DIR
        if [ ! -d "$BUILD_DIR" ]; then
          mkdir -p $BUILD_DIR
          cd $BUILD_DIR
          cmake ..
          make -j$(nproc)
          make test
        fi

        cd $DEPS_DIR/$CERES_DIR/$BUILD_DIR
        sudo make -j$(nproc) install
fi
