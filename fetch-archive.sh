#!/bin/sh
# -------------------------------------------------------------------------
#  Automatic script for OpenSSL archive download
#
#  Copyright 2016 Juraj Durech. All rights reserved.
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#  http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
# -------------------------------------------------------------------------

source ./openssl-version.sh 

VERSION=$COMMON_OPENSSL_VERSION

if [ -z "$VERSION" ]; then
	echo "No version is specified"
	exit 1;
fi

set -e
	
function download_openssl_file {
	file=$1
	url="https://www.openssl.org/source/$file"
	if [ ! -e $file ]; then
		echo "Downloading $file from $url"
	    curl -f -O $url || exit 1
	else
		echo "You have already downloaded $file"
	fi
}

download_openssl_file "openssl-${VERSION}.tar.gz"
download_openssl_file "openssl-${VERSION}.tar.gz.sha256"

# validate SHA256 sum
hash=$(<openssl-${VERSION}.tar.gz.sha256)
echo "$hash  openssl-${VERSION}.tar.gz" > openssl-${VERSION}.tar.gz.hash
shasum -a 256 -c openssl-${VERSION}.tar.gz.hash

echo "Download OK."
