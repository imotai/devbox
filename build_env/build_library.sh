#!/bin/bash

# Copyright 2022 author of devbox
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# install_deps.sh: build and install dependencies into to specific directory.
# Installation directory is /depends/thirdparty, while source file located in
# /depends/thirdsrc

set -eE
set -x

if [ -d '/opt/rh/devtoolset-7' ] ; then
    # shellcheck disable=SC1091
    source /opt/rh/devtoolset-7/enable
fi

if [ -d '/opt/rh/sclo-git212' ] ; then
    # shellcheck disable=SC1091
    source /opt/rh/sclo-git212/enable
fi
if [ -d '/opt/rh/python27' ] ; then
    # shellcheck disable=SC1091
    source /opt/rh/python27/enable
fi

DEPS_SOURCE=/depends/thirdsrc
DEPS_PREFIX=/depends/thirdparty
DEPS_CONFIG="--prefix=$DEPS_PREFIX --disable-shared --with-pic"

export CXXFLAGS=" -O3 -fPIC"
export CFLAGS=" -O3 -fPIC"

mkdir -p "$DEPS_PREFIX/lib" "$DEPS_PREFIX/include" "$DEPS_SOURCE"
export PATH=${DEPS_PREFIX}/bin:$PATH

if ! command -v nproc; then
	alias nproc='sysctl -n hw.logicalcpu'
fi

pushd "$DEPS_SOURCE"

echo "installing cmake ...."
# install cmake
tar xzf cmake-3.19.7-Linux-x86_64.tar.gz
pushd cmake-3.19.7-Linux-x86_64
find . -type f -exec install -D -m 755 {} /usr/local/{} \; > /dev/null
echo "install cmake done"
popd

if [ ! -f gtest_succ ]; then
	echo "installing gtest ...."
	tar xzf googletest-release-1.10.0.tar.gz

	pushd googletest-release-1.10.0
	cmake -DCMAKE_INSTALL_PREFIX="$DEPS_PREFIX" -DCMAKE_CXX_FLAGS=-fPIC
	make "-j$(nproc)"
	make install
	popd
	touch gtest_succ
	echo "install gtest done"
fi

if [ ! -f "absl_succ" ]; then
	echo "installing gtest ...."
	tar xzf a50ae369a30f99f79d7559002aba3413dac1bd48.tar.gz
	pushd abseil-cpp-a50ae369a30f99f79d7559002aba3413dac1bd48
	cmake -DCMAKE_INSTALL_PREFIX="$DEPS_PREFIX" -DCMAKE_CXX_FLAGS=-fPIC -DABSL_ENABLE_INSTALL=ON -DCMAKE_BUILD_TYPE=Release -DCMAKE_CXX_STANDARD=17 -DABSL_USE_GOOGLETEST_HEAD=OFF  -DCMAKE_POSITION_INDEPENDENT_CODE=ON 
	make "-j$(nproc)"
	make install
	popd
	touch absl_succ
	echo "install absl done"
fi

if [ -f "zlib_succ" ]; then
	echo "zlib exist"
else
	echo "installing zlib..."
	tar xzf zlib-1.2.11.tar.gz
	pushd zlib-1.2.11
	sed -i '/CFLAGS="${CFLAGS--O3}"/c\  CFLAGS="${CFLAGS--O3} -fPIC"' configure
	./configure --static --prefix="$DEPS_PREFIX"
	make -j"$(nproc)"
	make install
	popd
	touch zlib_succ
	echo "install zlib done"
fi

if [ -f "protobuf_succ" ]; then
	echo "protobuf exist"
else
	echo "start install protobuf ..."
	tar zxf protobuf-3.6.1.3.tar.gz
	pushd protobuf-3.6.1.3
	./autogen.sh && ./configure $DEPS_CONFIG CPPFLAGS=-I${DEPS_PREFIX}/include LDFLAGS=-L${DEPS_PREFIX}/lib  -disable-shared --with-pic
	make -j"$(nproc)"
	make install
	popd
	touch protobuf_succ
	echo "install protobuf done"
fi

if [ -f "snappy_succ" ]; then
	echo "snappy exist"
else
	echo "start install snappy ..."
	tar zxf snappy-1.1.1.tar.gz
	pushd snappy-1.1.1
	./configure $DEPS_CONFIG
	make "-j$(nproc)"
	make install
	popd

	touch snappy_succ
	echo "install snappy done"
fi

if [ -f "gflags_succ" ]; then
	echo "gflags-2.2.0.tar.gz exist"
else
	tar zxf gflags-2.2.0.tar.gz
	pushd gflags-2.2.0
	cmake -DCMAKE_INSTALL_PREFIX="$DEPS_PREFIX" -DGFLAGS_NAMESPACE=google -DCMAKE_CXX_FLAGS=-fPIC
	make "-j$(nproc)"
	make install
	popd
	touch gflags_succ
	echo "install gflags done"
fi

if [ -f "unwind_succ" ]; then
	echo "unwind_exist"
else
	tar zxf libunwind-1.1.tar.gz
	pushd libunwind-1.1
	autoreconf -i
	./configure --prefix="$DEPS_PREFIX"
    make -j"$(nproc)"
    make install
	popd

	touch unwind_succ
fi

if [ -f "gperf_tool" ]; then
	echo "gperf_tool exist"
else
	tar zxf gperftools-2.5.tar.gz
	pushd gperftools-2.5
	./configure --enable-cpu-profiler --enable-heap-checker --enable-heap-profiler --enable-static --prefix="$DEPS_PREFIX"
	make "-j$(nproc)"
	make install
	popd
	touch gperf_tool
fi

if [ -f "leveldb_succ" ]; then
	echo "leveldb exist"
else
    # TODO fix compile on leveldb 1.23
	tar zxf leveldb-1.20.tar.gz
	pushd leveldb-1.20
	sed -i 's/^OPT ?= -O2 -DNDEBUG/OPT ?= -O2 -DNDEBUG -fPIC/' Makefile
	make "-j$(nproc)"
	cp -rf include/* "$DEPS_PREFIX/include"
	cp out-static/libleveldb.a "$DEPS_PREFIX/lib"
	popd
	touch leveldb_succ
fi

if [ -f "openssl_succ" ]; then
	echo "openssl exist"
else
	unzip OpenSSL_1_1_0.zip
	pushd openssl-OpenSSL_1_1_0
	./config --prefix="$DEPS_PREFIX" --openssldir="$DEPS_PREFIX"
	make "-j$(nproc)"
	make install
	rm -rf "$DEPS_PREFIX"/lib/libssl.so*
	rm -rf "$DEPS_PREFIX"/lib/libcrypto.so*
	popd
	touch openssl_succ
	echo "openssl done"
fi

if [ -f "glog_succ" ]; then
	echo "glog exist"
else
	echo "installing glog ..."
	tar xzf glog-0.4.0.tar.gz
	pushd glog-0.4.0
	./autogen.sh && CXXFLAGS=-fPIC ./configure --prefix="$DEPS_PREFIX"
	make -j"$(nproc)" install
	popd
	touch glog_succ
	echo "installed glog"
fi

if [ -f "brpc_succ" ]; then
	echo "brpc exist"
else
    echo "installing brpc..."
	unzip incubator-brpc.zip
	pushd incubator-brpc-*
	sh config_brpc.sh --with-glog --headers="$DEPS_PREFIX/include" --libs="$DEPS_PREFIX/lib"
	make "-j$(nproc)" libbrpc.a output/include
	cp -rf output/include/* "$DEPS_PREFIX/include/"
	cp libbrpc.a "$DEPS_PREFIX/lib"
	popd

	touch brpc_succ
	echo "brpc done"
fi

if [ -f "zk_succ" ]
then
    echo "zk exist"
else
    echo "installing zookeeper..."
    tar -zxf apache-zookeeper-3.4.14.tar.gz
    pushd zookeeper-3.4.14/zookeeper-client/zookeeper-client-c
    autoreconf -if
    ./configure --prefix="$DEPS_PREFIX"
    make -j"$(nproc)"
    make install
    popd
    touch zk_succ
    echo "installed zookeeper c"
fi

if [ -f "bison_succ" ]; then
	echo "bison exist"
else
    echo "installing bison...."
	tar zxf bison-3.4.tar.gz
	pushd bison-3.4
	./configure --prefix="$DEPS_PREFIX"
	make install
	popd
	touch bison_succ
    echo "install bison done"
fi

if [ -f "benchmark_succ" ]; then
	echo "benchmark exist"
else
    echo "installing benchmark...."
	tar zxf v1.5.0.tar.gz
	pushd benchmark-1.5.0
	mkdir -p build
	cd build
	cmake -DCMAKE_INSTALL_PREFIX="$DEPS_PREFIX" -DCMAKE_CXX_FLAGS=-fPIC -DBENCHMARK_ENABLE_GTEST_TESTS=OFF ..
	make -j"$(nproc)"
	make install
	popd
	touch benchmark_succ
    echo "install benchmark done"
fi

if [ -f "swig_succ" ]; then
	echo "swig exist"
else
    echo "installing swig ...."
	tar -zxf swig-4.0.1.tar.gz
	pushd swig-4.0.1
	./autogen.sh
	./configure --without-pcre --prefix="$DEPS_PREFIX"
	make -j"$(nproc)"
	make install
	popd
	touch swig_succ
    echo "install swig done"
fi

if [ -f "yaml_succ" ]; then
	echo "yaml-cpp installed"
else
    echo "installing yaml-cpp...."
	tar -zxf yaml-cpp-0.6.3.tar.gz
	pushd yaml-cpp-yaml-cpp-0.6.3
	mkdir -p build
	cd build
	cmake -DCMAKE_INSTALL_PREFIX="$DEPS_PREFIX" ..
	make -j"$(nproc)"
	make install
	popd
	touch yaml_succ
    echo "install yaml-cpp done"
fi

if [ -f "llvm_succ" ]; then
	echo "llvm_exist"
else
    echo "installing llvm...."
	tar xf llvm-9.0.0.src.tar.xz
	pushd llvm-9.0.0.src
	mkdir -p build && cd build
	cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX="$DEPS_PREFIX" -DLLVM_TARGETS_TO_BUILD=X86  -DCMAKE_CXX_FLAGS=-fPIC ..
	make "-j$(nproc)"
	make install
	popd
	touch llvm_succ
    echo "install llvm done"
fi

if [ -f "boost_succ" ]; then
	echo "boost exist"
else
    echo "installing boost...."
	tar -zxf boost_1_69_0.tar.gz
	pushd boost_1_69_0
	./bootstrap.sh
	./b2 --without-python link=static cxxflags=-fPIC cflags=-fPIC release install --prefix="$DEPS_PREFIX"
	popd
	touch boost_succ
    echo "install boost done"
fi

if [ -f "zetasql_succ" ]; then
    echo "zetasql_succ"
else
    echo "installing zetasql...."
    curl -SL -o libzetasql-0.2.6-linux-gnu-x86_64-centos.tar.gz https://github.com/4paradigm/zetasql/releases/download/v0.2.6/libzetasql-0.2.6-linux-gnu-x86_64-centos.tar.gz
    tar -zxvf libzetasql-0.2.6-linux-gnu-x86_64-centos.tar.gz
    pushd libzetasql-0.2.6
    cp -rf include/* $DEPS_PREFIX/include/
    cp -rf lib/* $DEPS_PREFIX/lib/
    popd
    touch zetasql_succ
    echo "install zetasql done"
fi


# Remove dynamic library files for static link
find /depends/thirdparty/lib/ -name "lib*so*" | grep -v "libRemarks" | grep -v "libLTO" | xargs rm
find /depends/thirdparty/lib64/ -name "lib*so*" | grep -v "libRemarks" | grep -v "libLTO" | xargs rm

popd
