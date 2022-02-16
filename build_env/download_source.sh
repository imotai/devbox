#!/bin/bash
# Copyright 2022 the author of devbox
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

set -eE

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'
DOWNLOAD_DIR=${1:-/depends/thirdsrc}
LIBRARY_CSV="$PWD/library.csv"

download()
{
    if [ $# -ne 2 ]; then
        echo "usage: fetch url output_file"
        exit 1
    fi
    local url=$1
    local file_name=$2
    if [ ! -e  "$file_name" ]; then
        echo -e "${GREEN}downloading $url ...${NC}"
        curl -SL -o "$file_name" "$url"
        echo -e "${GREEN}download $url${NC}"
    fi
}

mkdir -p "$DOWNLOAD_DIR"
pushd "$DOWNLOAD_DIR"
echo -e "${GREEN}downloading source into $DOWNLOAD_DIR${NC}"
less $LIBRARY_CSV | while IFS="," read -r url pkg; do download $url $pkg; done
popd
