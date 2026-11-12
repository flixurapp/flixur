# this is entirely slop but it works so idc

{
  lib,
  stdenv,
  flutter,
  androidenv,
  jdk,
  cacert,
  runCommand,
  makeWrapper,
}:
let
  # dart spawned by flutter for pub does not respect SSL_CERT_FILE and has a
  # hardcoded cert path that doesn't exist under nix (see
  # pkgs/development/compilers/flutter/build-support/build-flutter-application.nix)
  pubDart =
    runCommand "dart-with-certs"
      {
        nativeBuildInputs = [ makeWrapper ];
      }
      ''
        mkdir --parents "$out/bin"
        makeWrapper ${flutter.dart}/bin/dart "$out/bin/dart" \
          --add-flags "--root-certs-file=${cacert}/etc/ssl/certs/ca-bundle.crt"
      '';

  # Android SDK components required by the app and its plugins:
  # - platforms 35+36: the app uses flutter.compileSdkVersion (36) and the
  #   jni/jni_flutter plugins pin compileSdk 35
  # - build-tools 35+36: AGP default
  # - NDK 28.2.13676358: flutter.ndkVersion (jni native build + lib stripping)
  # - cmake 3.22.1: jni plugin externalNativeBuild
  androidSdk =
    ((androidenv.override { licenseAccepted = true; }).composeAndroidPackages {
      platformVersions = [
        "35"
        "36"
      ];
      buildToolsVersions = [
        "35.0.0"
        "36.0.0"
      ];
      includeNDK = true;
      ndkVersion = "28.2.13676358";
      includeCmake = true;
      cmakeVersions = [ "3.22.1" ];
    }).androidsdk;

  # Only files that influence the gradle dependency set. App code is excluded
  # (a stub entrypoint is provided below), so code changes don't invalidate
  # the (network-heavy) gradle cache fetch.
  gradleDepsSrc = lib.cleanSourceWith {
    src = ../flutter;
    filter =
      path: type:
      let
        rel = lib.removePrefix (toString ../flutter) (toString path);
        name = baseNameOf (toString path);
        excludedNames = [
          ".dart_tool"
          ".gradle"
          ".idea"
          ".git"
          ".vscode"
          ".zed"
          "build"
          "local.properties"
          ".flutter-plugins-dependencies"
        ];
      in
      !(lib.elem name excludedNames)
      && !(lib.hasSuffix ".iml" name)
      && (
        rel == ""
        || lib.elem rel [
          "/pubspec.yaml"
          "/pubspec.lock"
          "/assets"
          "/android"
          "/openapi"
        ]
        || lib.hasPrefix "/assets/" rel
        || lib.hasPrefix "/android/" rel
        || lib.hasPrefix "/openapi/" rel
      );
  };

  # The gradle wrapper files (gradlew, gradle-wrapper.jar) are gitignored in
  # this repo, so restore them from the flutter SDK's artifacts (the flutter
  # tool does not repair missing wrappers in existing projects).
  installGradleWrapper = ''
    if [ ! -e android/gradlew ]; then
      mkdir --parents android/gradle/wrapper
      cp "${flutter}/bin/cache/artifacts/gradle_wrapper/gradlew" android/gradlew
      cp "${flutter}/bin/cache/artifacts/gradle_wrapper/gradle/wrapper/gradle-wrapper.jar" android/gradle/wrapper/
      chmod +x android/gradlew
    fi
    patchShebangs android/gradlew
  '';

  # Fixed-output derivation running one full online gradle build and capturing
  # the maven dependency cache and gradle distribution. Both are
  # content-deterministic for a given dependency set (verified across
  # independent runs), so the hash can be pinned; bump it whenever the gradle
  # dependency set changes (flutter SDK bump, plugin bump, gradle config
  # change). The actual APK build is a normal (pure, offline) derivation below.
  gradleDeps = stdenv.mkDerivation {
    name = "flixur-flutter-gradle-deps";
    src = gradleDepsSrc;

    outputHash = "sha256-wcJeBvDYXpHoPDEZLUK+2d8CsNtrefcSKjyrhaQICU0=";
    outputHashMode = "recursive";
    outputHashAlgo = "sha256";

    # stdenv's fixup phase would patch shebangs inside $out (e.g. the extracted
    # gradle launcher), changing the fixed-output's content and breaking the
    # pinned hash
    dontFixup = true;

    nativeBuildInputs = [
      flutter
      jdk
    ];

    unpackPhase = ''
            runHook preUnpack
            cp --recursive "$src" ./source
            chmod --recursive u+w ./source
            # the app code is excluded from this source; provide a stub entrypoint
            # so the full gradle build runs without real app code
            mkdir --parents ./source/lib
            cat > ./source/lib/main.dart <<'STUBEOF'
      import 'package:flutter/material.dart';

      void main() {
        runApp(const Placeholder());
      }
      STUBEOF
            runHook postUnpack
    '';
    sourceRoot = "source";

    buildPhase = ''
      runHook preBuild
      ${installGradleWrapper}

      export HOME="$NIX_BUILD_TOP/home"
      export GRADLE_USER_HOME="$NIX_BUILD_TOP/gradle-home"
      export ANDROID_USER_HOME="$NIX_BUILD_TOP/android-user"
      export ANDROID_HOME="${androidSdk}/libexec/android-sdk"
      export ANDROID_SDK_ROOT="$ANDROID_HOME"
      export JAVA_HOME="${jdk.home}"
      mkdir --parents "$HOME" "$GRADLE_USER_HOME" "$ANDROID_USER_HOME"

      # pub (dart) needs TLS certs under nix
      export NIX_FLUTTER_PUB_DART="${pubDart}/bin/dart"
      # git (pub git dependencies) too
      export GIT_SSL_CAINFO="${cacert}/etc/ssl/certs/ca-bundle.crt"

      printf 'org.gradle.daemon=false\norg.gradle.jvmargs=-Xmx4G -XX:MaxMetaspaceSize=1G\n' \
        >> "$GRADLE_USER_HOME/gradle.properties"

      flutter pub get
      flutter build apk --release
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      mkdir --parents "$out/caches/modules-2" "$out/wrapper"
      cp --recursive "$GRADLE_USER_HOME/caches/modules-2/files-2.1" "$out/caches/modules-2/"
      cp --recursive "$GRADLE_USER_HOME/wrapper/dists" "$out/wrapper/"
      runHook postInstall
    '';

    meta.platforms = [ "x86_64-linux" ];
  };

in
flutter.buildFlutterApplication {
  pname = "flixur-flutter-android";
  version = "0.1.0+1";
  src = ../flutter;
  # generated via `yq . pubspec.lock > pubspec.lock.json` (see flake.nix);
  # must stay in sync with pubspec.lock, which gradleDeps resolves its
  # dependency set from
  pubspecLock = lib.importJSON ../flutter/pubspec.lock.json;
  # hashes for git-sourced pub dependencies (see pubspec.lock.json)
  gitHashes.iconify_design = "sha256-2i8MA5B6NXCr93oZqcnQJ0Ajz9Un0emMC1ayn1A//MA=";

  # nixpkgs' buildFlutterApplication only implements linux/web build phases;
  # we reuse it for its offline pub-cache machinery (pubspecLock based) and
  # provide our own android build phase below. The flutter it wraps internally
  # lacks android artifacts, so the android build uses `flutter` (which ships
  # them) directly.
  targetFlutterPlatform = "linux";
  dontDartBuild = true;
  # the debug output holds the --split-debug-info symbols below; normally
  # targetFlutterPlatform = "linux" would add it for us, but we can declare it
  # explicitly so the build doesn't depend on that
  # disabled since its upstream but if it ever changes its here
  # outputs = [ "debug" ];

  nativeBuildInputs = [
    flutter
    jdk
  ];

  # NOTE: everything inside this Nix indented string shares a common leading
  # indent that Nix strips. The minimum is currently 4 spaces; if any line
  # (especially the 'REPOEOF'/'WRAPEOF' heredoc terminators) is reindented
  # below that, the terminators keep leading whitespace and bash no longer
  # recognizes them.
  buildPhase = ''
        runHook preBuild
        ${installGradleWrapper}

        export HOME="$NIX_BUILD_TOP/home"
        export GRADLE_USER_HOME="$NIX_BUILD_TOP/gradle-home"
        export ANDROID_USER_HOME="$NIX_BUILD_TOP/android-user"
        export ANDROID_HOME="${androidSdk}/libexec/android-sdk"
        export ANDROID_SDK_ROOT="$ANDROID_HOME"
        export JAVA_HOME="${jdk.home}"
        mkdir --parents "$HOME" "$GRADLE_USER_HOME" "$ANDROID_USER_HOME"

        # seed the gradle caches from the captured online build
        # (maven artifacts + gradle distribution)
        mkdir --parents "$GRADLE_USER_HOME/caches/modules-2" "$GRADLE_USER_HOME/wrapper"
        cp --recursive "${gradleDeps}/caches/modules-2/files-2.1" "$GRADLE_USER_HOME/caches/modules-2/"
        cp --recursive "${gradleDeps}/wrapper/dists" "$GRADLE_USER_HOME/wrapper/"
        # store copies are read-only; gradle needs write access to its lock files
        chmod --recursive u+w "$GRADLE_USER_HOME"

        # build a flat maven repository from the captured gradle cache:
        # group/artifact/version/HASH/file -> group/artifact/version/file,
        # and dotted group directories -> maven's dot-as-path layout
        M2="$GRADLE_USER_HOME/offline-m2"
        mkdir --parents "$M2"
        cp --recursive "$GRADLE_USER_HOME/caches/modules-2/files-2.1/." "$M2/"
        find "$M2" -mindepth 5 -maxdepth 5 -type f -execdir mv {} ../ \;
        # merge the dotted group directories into maven's dot-as-path layout.
        # merge file contents (not the dirs themselves): a plain `mv dir target`
        # nests the dir inside target when a sibling with a longer dotted name
        # already created the parent path - order-dependent (find iterates in
        # filesystem order), which broke CI while working locally
        find "$M2" -mindepth 1 -maxdepth 1 -type d -name '*.*' | while read -r d; do
          target="$M2/$(basename "$d" | tr '.' '/')"
          mkdir --parents "$target"
          find "$d" -mindepth 1 -maxdepth 1 -exec mv {} "$target"/ \;
          rmdir "$d"
        done

        printf 'org.gradle.daemon=false\norg.gradle.jvmargs=-Xmx4G -XX:MaxMetaspaceSize=1G\n' \
          >> "$GRADLE_USER_HOME/gradle.properties"

        # point gradle at the local maven repository. gradle --offline would also
        # block file:// repositories, and org.gradle.offline in gradle.properties
        # is not honored (observed offline=false in both sandbox and host builds),
        # so this init script (picked up automatically from GRADLE_USER_HOME)
        # prepends the local repository and makes settings repositories take
        # precedence over the network repositories AGP adds to projects.
        export GRADLE_OFFLINE_M2="$M2"
        mkdir --parents "$GRADLE_USER_HOME/init.d"
        cat > "$GRADLE_USER_HOME/init.d/offline-repo.gradle" <<'REPOEOF'
    def repoUri = new File(System.getenv('GRADLE_OFFLINE_M2')).toURI()
    gradle.beforeSettings { settings ->
      settings.pluginManagement {
        repositories {
          maven { url = repoUri }
        }
      }
      settings.dependencyResolutionManagement {
        repositoriesMode = org.gradle.api.initialization.resolve.RepositoriesMode.PREFER_SETTINGS
        repositories {
          maven { url = repoUri }
        }
      }
    }
    gradle.beforeProject { project ->
      project.buildscript {
        repositories {
          maven { url = repoUri }
        }
      }
    }
    REPOEOF

        # wrap gradlew so the pub cache path rewrite below runs after the flutter
        # tool has written its plugin manifest, but before gradle configures the
        # (read-only, nix-store) plugin projects
        mv android/gradlew android/gradlew.orig
        cat > android/gradlew <<'WRAPEOF'
    #!/bin/sh
    APP_ROOT="$(dirname "$0")/.."
    PUB_COPY="$NIX_BUILD_TOP/pub-cache"
    if [ -e "$APP_ROOT/.dart_tool/package_config.json" ]; then
      mkdir --parents "$PUB_COPY"
      grep -ohE '/nix/store/[a-z0-9]{32}-pub-[^"]*' \
        "$APP_ROOT/.dart_tool/package_config.json" "$APP_ROOT/.flutter-plugins-dependencies" 2>/dev/null \
        | sort -u \
        | while read -r p; do
            # package_config rootUris end in "/."; normalize so basename works
            p=$(printf '%s' "$p" | sed 's|/\.$||')
            name=$(basename "$p")
            if [ ! -e "$PUB_COPY/$name" ]; then
              cp --recursive "$p" "$PUB_COPY/$name"
              chmod --recursive u+w "$PUB_COPY/$name"
            fi
            sed --in-place "s|$p|$PUB_COPY/$name|g" \
              "$APP_ROOT/.dart_tool/package_config.json" "$APP_ROOT/.flutter-plugins-dependencies" 2>/dev/null
          done
    fi
    exec "$(dirname "$0")/gradlew.orig" "$@"
    WRAPEOF
        chmod +x android/gradlew

        # the pub machinery leaves .dart_tool read-only; the flutter tool
        # (and its nested assemble invocations from gradle) may need to write
        # freshness state there
        chmod --recursive u+w .dart_tool || true
        ${flutter}/bin/flutter build apk --release --no-pub --split-debug-info="$debug"
        runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -Dm644 build/app/outputs/flutter-apk/app-release.apk "$out/app-release.apk"
    install -Dm644 build/app/outputs/flutter-apk/app-release.apk.sha1 "$out/app-release.apk.sha1"
    mkdir --parents "$out/nix-support"
    echo "file binary-dist $out/app-release.apk" >> "$out/nix-support/hydra-build-products"
    runHook postInstall
  '';

  passthru = {
    inherit gradleDeps androidSdk;
  };

  meta = {
    description = "Flixur Android app";
    platforms = [ "x86_64-linux" ];
  };
}
