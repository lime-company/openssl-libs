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

set -e

CURRENTPATH=`pwd`
CURRENTCMD=$(basename $0)
BUILDER_PATH=/tmp/openssl-build

function clone_myself_and_run_elsewhere() {
	
	rm -rf "${BUILDER_PATH}"
	mkdir -p "${BUILDER_PATH}"
	echo "cp ${CURRENTPATH}/*.sh ${BUILDER_PATH}"
	cp ${CURRENTPATH}/*.sh ${BUILDER_PATH}
	cp -R ${CURRENTPATH}/patches ${BUILDER_PATH}
	
	# execute build
	pushd ${BUILDER_PATH}
	./${CURRENTCMD}
	popd
	
	echo "### Copying results to repository"
	
	rm -rf ${CURRENTPATH}/android
	rm -rf ${CURRENTPATH}/ios
	cp -R  ${BUILDER_PATH}/android 	${CURRENTPATH}
	cp -R  ${BUILDER_PATH}/ios		${CURRENTPATH}
	rm -rf "${BUILDER_PATH}"
	echo "### Done"
}

function build_everything() {
	echo "### Fetching archive..."
	${CURRENTPATH}/fetch-archive.sh

	echo "### Building Android..."
	${CURRENTPATH}/build-android.sh

	echo "### Building IOS..."
	${CURRENTPATH}/build-ios.sh	
	
	echo "### ALL-IN-ONE build DONE"
}

if [ "${CURRENTPATH}" == "${BUILDER_PATH}" ]; then
	build_everything
else
	clone_myself_and_run_elsewhere
fi