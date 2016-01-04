#!/bin/bash

stub=$1; shift
set -e

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
export ATC_URL=${ATC_URL:-"http://192.168.100.4:8080"}
export fly_target=${fly_target:-local}
export pipeline="simple-go-web-app"
echo "Concourse API target ${fly_target}"
echo "Concourse API $ATC_URL"
echo "Concourse Pipeline: $pipeline"

realpath() {
    [[ $1 = /* ]] && echo "$1" || echo "$PWD/${1#./}"
}

if [[ "${stub}X" == "X" ]]; then
  echo "USAGE: update-pipeline.sh path/to/credentials.yml"
  exit 1
fi
stub=$(realpath $stub)
if [[ ! -f ${stub} ]]; then
  echo "USAGE: update-pipeline.sh path/to/credentials.yml"
  exit 1
fi

pushd $DIR
  yes y | fly -t ${fly_target} set-pipeline -c pipeline.yml -p ${pipeline} --load-vars-from ${stub}
#  curl $ATC_URL/pipelines/$pipeline/jobs/deploy-app/builds -X POST
#  fly -t ${fly_target} watch -j deploy-app
popd
