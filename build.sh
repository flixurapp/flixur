#!/bin/bash

# Clear old build directory.
rm -rf build
mkdir build

# Build the client.
cd frontend || exit
pnpm i
pnpm build
cp -r build/* ../server/static/

cd ../server || exit

# Copy/Create logo.
cp ../logo.svg ./static/
ffmpeg -y -i ./static/logo.svg ./static/logo.png

# Build the server.
go build -o ../build/flixur
chmod +x ../build/flixur

echo "Done building."
