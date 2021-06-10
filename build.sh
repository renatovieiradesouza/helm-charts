#!/bin/bash

debug=false
full=false
no_mirror=false

while [ $# -gt 0 ]; do
  case $1 in
    -d|--debug) debug=true;;
    -f|--full) full=true;;
    -n|--no-mirror) no_mirror=true;;
    -h|--help|help) echo "Usage: $0 [-f|--full] [-n|--no-mirror]"; exit 0;;
    *) echo "Usage: $0 [-f|--full] [-n|--no-mirror]"; exit 1
  esac
  shift
done

$debug && set -x

if $full; then
  rm -rf repo
fi

charts=( charts/* )

mkdir -p repo/getupcloud

echo Downloading git repos
./git-download.sh https://github.com/CrunchyData/postgres-operator.git v4.6.2 && charts+=( git/postgres-operator/installers/helm/ )

echo Charts sources: ${charts[*]}

echo Creating charts: repo/getupcloud
helm package -d repo/getupcloud "${charts[@]}"
echo Creating index: repo/getupcloud
helm repo index repo/getupcloud
cp index.html repo/

$no_mirror || ./mirror.sh
