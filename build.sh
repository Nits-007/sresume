#!/usr/bin/env bash
# Exit immediately if a command exits with a non-zero status
set -e

# 1. Download and extract Flutter SDK
git clone https://github.com/flutter/flutter.git -b stable
export PATH="$PATH:`pwd`/flutter/bin"

# 2. Set up Flutter environment
flutter doctor
flutter config --enable-web

# 3. Get dependencies and build
flutter pub get
flutter build web --release --no-tree-shake-icons

# 4. Success!
echo "Build finished successfully."
