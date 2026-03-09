#!/bin/bash
set -e

echo "==> Adding arm64 architecture..."
sudo dpkg --add-architecture arm64
sudo apt-get update

echo "==> Installing cross-compilation dependencies for arm64..."
sudo apt-get install -y \
    build-essential \
    gcc-aarch64-linux-gnu \
    libc6:arm64 \
    dpkg-dev \
    debhelper \
    quilt \
    curl

echo ""
echo "==> Done. Ready to build with ./build.sh"
