#!/usr/bin/env bash

openapi-generator-cli generate \
	-i http://localhost:8787/api/openapi.json \
	-g typescript-fetch \
	-o src \
	--additional-properties=supportsES6=true
