#!/bin/bash

# Generates all types/protos/APIs.

./proto.sh
./tygo.sh

cd server || exit

cd ../openapi || exit
pnpm i --frozen-lockfile
./generate.sh
