# Clean up stale dirs.
clean:
    nix run .#flutter-clean

# Run treewide code generators.
generate:
    nix run .#generate
