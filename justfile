# Clean up stale dirs.
clean:
    nix run .#flutter-clean

# Run repo-wide code generators.
generate:
    nix run .#generate

# Run repo-wide test suite.
test:
    nix run .#test-server
