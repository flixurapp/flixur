# Clear old build directory.
rm -rf build
mkdir build

# Build the client.
cd frontend
pnpm i
pnpm build
cp -r build ../build/client
cd ..

# Build the server.
cd server
go build -o ../build/flixur
chmod +x ../build/flixur
cd ..

echo "Done building."
