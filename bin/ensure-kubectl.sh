#!/bin/bash

# MODIFIED by Ross Kukulinski <ross@kukulinski.com>
# Copyright 2016 Ross Kukulinski All rights reserved

# Copyright 2014 The Kubernetes Authors All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# used to install kubectl inside the build environment plus other tools these scripts leverage.
# uncomment for troubleshooting if required
# set -xv

PKG_MANAGER=$( command -v yum || command -v apt-get ) || echo "Neither yum nor apt-get found"

#make sure sudo is installed
if [ ! -e "/usr/bin/sudo" ]; then
   ${PKG_MANAGER} install -y sudo
fi

KUBE_VERSION=${KUBE_VERSION:-1.3.6}
# remove default setting of requiretty if it exists
sed -i '/Defaults requiretty/d' /etc/sudoers

#make sure wget is installed
if [ ! -e "/usr/bin/wget" ]; then
   sudo ${PKG_MANAGER} install -y wget
fi

#make sure jq is installed
if [ ! -e "/usr/bin/jq" ]; then
    sudo ${PKG_MANAGER} install -y jq
fi

#make sure envsubst is installed
if [ ! -e "/usr/bin/envsubst" ]; then
    sudo ${PKG_MANAGER} install -y gettext
fi

# make the temp directory
if [ ! -e ~/.kube ]; then
    mkdir -p ~/.kube;
fi

if [ ! -e ~/.kube/kubectl ]; then
    wget https://storage.googleapis.com/kubernetes-release/release/v${KUBE_VERSION}/bin/linux/amd64/kubectl -O ~/.kube/kubectl
    chmod +x ~/.kube/kubectl
fi
pwd
