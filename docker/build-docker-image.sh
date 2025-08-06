#!/bin/bash
DIR=`dirname $(realpath $0)`

cd ${DIR}
docker image build -t palworld-server-proton .
