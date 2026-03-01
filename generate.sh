#!/usr/bin/env bash

# Generates all types/protos/APIs.

./proto.sh
./tygo.sh

cd server || exit
go run . &

cd ../openapi || exit
./generate.sh
killport 8787
