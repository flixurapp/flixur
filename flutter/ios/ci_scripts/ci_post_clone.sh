#!/bin/sh
# Bootstrap Flutter for Xcode Cloud; runs right after the repo is cloned.
#
# Xcode Cloud expects this script in a `ci_scripts` directory next to the
# Xcode project and runs it from within that directory:
# https://developer.apple.com/documentation/xcode/writing-custom-scripts
#
# The temporary build environment is empty: no Flutter, no dart. `pub get`
# and `flutter build ios --config-only` generate the ephemeral iOS glue
# (Generated.xcconfig, .flutter-plugins-dependencies) that is not committed.

set -eu

# Keep in sync with the flutter version from the flake devshell.
FLUTTER_VERSION="3.47.4"

REPO_DIR="${CI_PRIMARY_REPOSITORY_PATH:-${CI_WORKSPACE:?CI_WORKSPACE is not set}}"
APP_DIR="$REPO_DIR/flutter"
# Xcode Cloud restores derived data between builds of the same workflow
# (unless the workflow uses Clean builds). Install the SDK there so repeat
# builds skip the ~2.3 GB download; falls back to $HOME when the path is
# unset or the cache was wiped, in which case we just re-download.
CACHE_BASE="${CI_DERIVED_DATA_PATH:-$HOME}"
SDK_DIR="$CACHE_BASE/flutter-$FLUTTER_VERSION"

if [ ! -x "$SDK_DIR/bin/flutter" ]; then
	# Release archives: macos = Intel, macos_arm64 = Apple Silicon.
	case "$(uname -m)" in
	arm64) ARCHIVE_PREFIX="flutter_macos_arm64_" ;;
	x86_64) ARCHIVE_PREFIX="flutter_macos_" ;;
	*)
		echo "unsupported arch: $(uname -m)" >&2
		exit 1
		;;
	esac

	ARCHIVE="$ARCHIVE_PREFIX$FLUTTER_VERSION-stable.zip"
	URL="https://storage.googleapis.com/flutter_infra_release/releases/stable/macos/$ARCHIVE"
	echo "Downloading $URL"

	TMP_DIR="$(mktemp -d)"
	curl -sSfL "$URL" -o "$TMP_DIR/$ARCHIVE"
	unzip -q "$TMP_DIR/$ARCHIVE" -d "$TMP_DIR"
	mv "$TMP_DIR/flutter" "$SDK_DIR"
	rm -rf "$TMP_DIR"
fi

export PATH="$SDK_DIR/bin:$PATH"

echo "Using: $(flutter --version)"

flutter config --no-analytics
flutter precache --ios

(cd "$APP_DIR" && flutter pub get)
(cd "$APP_DIR" && flutter build ios --config-only)

# Reuse pubspec's version name, but take the build number from Xcode Cloud so
# every TestFlight upload is unique (pubspec's +1 would collide).
GEN_XCCONFIG="$APP_DIR/ios/Flutter/Generated.xcconfig"
echo "FLUTTER_BUILD_NUMBER=${CI_BUILD_NUMBER:-1}" >>"$GEN_XCCONFIG"
echo "Set FLUTTER_BUILD_NUMBER=${CI_BUILD_NUMBER:-1} in $GEN_XCCONFIG"
