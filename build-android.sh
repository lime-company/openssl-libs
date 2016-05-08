#!/bin/sh
# -------------------------------------------------------------------------
# Copyright 2016 Juraj Durech <durech.juraj@gmail.com>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# -------------------------------------------------------------------------

source ./openssl-version.sh
VERSION=$COMMON_OPENSSL_VERSION
CURRENTPATH=`pwd`

if [ ! -e openssl-${VERSION}.tar.gz ]; then
	echo "Please run >> fetch-archive.sh << to download OpenSSL."
	exit 1
else
	echo "Using openssl-${VERSION}.tar.gz"
fi

mkdir -p "${CURRENTPATH}/src"
tar zxf openssl-${VERSION}.tar.gz -C "${CURRENTPATH}/src"

# Apply patches (the hard way)
cp "${CURRENTPATH}/patches/android_ui_openssl.c" "${CURRENTPATH}/src/openssl-${VERSION}/crypto/ui/ui_openssl.c"
# ...and the good way
cp "${CURRENTPATH}/patches/"*.patch "${CURRENTPATH}/src/openssl-${VERSION}"
pushd "${CURRENTPATH}/src/openssl-${VERSION}"
patch -p1 < 0001-Forcing-PIC-mode.patch
popd

LIB_DST="${CURRENTPATH}/android/lib"
INC_DST="${CURRENTPATH}/android/include"
mkdir -p "${INC_DST}"
mkdir -p "${LIB_DST}"

COMPILE_NDK=${NDK_ROOT}
COMPILE_API=${ANDROID_API_LEVEL}
COMPILE_GCC=${ANDROID_NDK_GCC_VERSION}
COMPILE_SRC="${CURRENTPATH}/src/openssl-${VERSION}"
COMPILE_DST="${CURRENTPATH}/android"

rm -rf "${COMPILE_DST}"

for ABI in ${ANDROID_ABIS}
do
	echo "-------------------------------------------------------------"
	echo "Building  ${ABI}"
	echo "-------------------------------------------------------------"
	
	./compile-android.sh ${COMPILE_NDK} ${COMPILE_SRC} ${COMPILE_API} ${ABI} ${COMPILE_GCC} ${COMPILE_DST}
	
	if [ ! -e "${COMPILE_DST}/lib/${ABI}/libcrypto.a" ]; then
		echo "Missing library for $ABI"
		exit 1
	fi
	# we don't need ssl library...
	rm -f "${COMPILE_DST}/lib/${ABI}/libssl.a"
done

rm -rf "${CURRENTPATH}/src"	

echo "-------------------------------------------------------------"
echo "Done for: ${ANDROID_ABIS}"
echo "-------------------------------------------------------------"