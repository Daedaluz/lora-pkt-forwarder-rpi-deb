#!/bin/bash
set -e

UPSTREAM_VERSION=2.1.0
UPSTREAM_TAG="V${UPSTREAM_VERSION}"
PKG_NAME=sx1302-hal
TARBALL_NAME="${PKG_NAME}_${UPSTREAM_VERSION}.orig.tar.gz"

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
BUILD_DIR="${SCRIPT_DIR}/build"

echo "==> Cleaning previous build..."
rm -rf "${BUILD_DIR}"
mkdir -p "${BUILD_DIR}"

echo "==> Downloading upstream source ${UPSTREAM_TAG}..."
curl -sL "https://github.com/Lora-net/sx1302_hal/archive/refs/tags/${UPSTREAM_TAG}.tar.gz" \
    -o "${BUILD_DIR}/${TARBALL_NAME}"

echo "==> Extracting source..."
cd "${BUILD_DIR}"
tar xzf "${TARBALL_NAME}"

# Rename extracted directory to match Debian conventions
mv sx1302_hal-${UPSTREAM_VERSION} "${PKG_NAME}-${UPSTREAM_VERSION}"

echo "==> Copying debian/ directory..."
cp -a "${SCRIPT_DIR}/debian" "${PKG_NAME}-${UPSTREAM_VERSION}/debian"

echo "==> Applying quilt patches..."
cd "${PKG_NAME}-${UPSTREAM_VERSION}"
export QUILT_PATCHES=debian/patches
quilt push -a || true

echo "==> Building package..."
dpkg-buildpackage -us -uc -b

echo ""
echo "==> Build complete. Package(s):"
ls -la "${BUILD_DIR}"/*.deb 2>/dev/null || echo "No .deb files found"
