FROM centos/python-36-centos7:latest
ENV TF_VERSION=1.15.2 \
    CMAKE_VERSION=3.16.3 \
    LLVM_VERSION=9.0.1
USER root
RUN yum update -y \
    && yum install -y \
      sudo \
      wget \
      git \
      centos-release-scl \
      ninja-build \
      devtoolset-8 \
    && yum clean all \
    && scl enable devtoolset-8 bash \
    && wget https://github.com/Kitware/CMake/releases/download/v$CMAKE_VERSION/cmake-$CMAKE_VERSION-Linux-x86_64.sh \
    && sh cmake-$CMAKE_VERSION-Linux-x86_64.sh --prefix=/usr \
    && wget https://github.com/llvm/llvm-project/releases/download/llvmorg-$LLVM_VERSION/llvm-$LLVM_VERSION.src.tar.xz \
    && wget https://github.com/llvm/llvm-project/releases/download/llvmorg-$LLVM_VERSION/clang-$LLVM_VERSION.src.tar.xz \
    && tar -xf llvm-$LLVM_VERSION.src.tar.xz \
    && cd llvm-$LLVM_VERSION.src \
    && tar -xf ../clang-$LLVM_VERSION.src.tar.xz -C tools \
    && mv tools/clang-$LLVM_VERSION.src tools/clang \
    && mkdir -v build \
    && cd build \
    && CC=gcc CXX=g++ cmake -DCMAKE_INSTALL_PREFIX=/usr \
       -DLLVM_ENABLE_FFI=ON                      \
       -DCMAKE_BUILD_TYPE=Release                \
       -DLLVM_BUILD_LLVM_DYLIB=ON                \
       -DLLVM_LINK_LLVM_DYLIB=ON                 \
       -DLLVM_ENABLE_RTTI=ON                     \
       -DLLVM_TARGETS_TO_BUILD="host"            \
       -DLLVM_BUILD_TESTS=OFF                    \
       -DLLVM_INCLUDE_TOOLS=bootstrap-only       \
       -DLLVM_OPTIMIZED_TABLEGEN=ON              \
       -Wno-dev -G Ninja ..
