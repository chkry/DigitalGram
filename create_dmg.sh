#!/bin/bash
#
# create_dmg.sh - Create a distributable DMG for DigitalGram
#

set -e

APP_NAME="DigitalGram"
VERSION="1.0.0"
DMG_NAME="${APP_NAME}-${VERSION}"
BUILD_DIR="build/Release"
DMG_DIR="dmg_temp"
FINAL_DMG="${APP_NAME}-${VERSION}.dmg"

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}Building ${APP_NAME}...${NC}"

# Build the app in Release mode
xcodebuild -scheme DigitalGram -configuration Release clean build \
    -derivedDataPath build | xcpretty || xcodebuild -scheme DigitalGram -configuration Release clean build -derivedDataPath build

# Check if build succeeded
if [ ! -d "build/Build/Products/Release/${APP_NAME}.app" ]; then
    echo "Error: Build failed or app not found"
    exit 1
fi

echo -e "${GREEN}Build successful!${NC}"
echo -e "${BLUE}Creating DMG...${NC}"

# Clean up any previous DMG artifacts
rm -rf "${DMG_DIR}"
rm -f "${FINAL_DMG}"
rm -f tmp_*.dmg

# Create temporary DMG directory
mkdir -p "${DMG_DIR}"

# Copy the app
cp -R "build/Build/Products/Release/${APP_NAME}.app" "${DMG_DIR}/"

# Create Applications symlink
ln -s /Applications "${DMG_DIR}/Applications"

# Create temporary DMG directly compressed
echo -e "${BLUE}Creating DMG...${NC}"
hdiutil create -srcfolder "${DMG_DIR}" -volname "${APP_NAME}" -fs HFS+ \
    -fsargs "-c c=64,a=16,e=16" -format UDZO -imagekey zlib-level=9 -o "${FINAL_DMG}"

# Clean up
rm -rf "${DMG_DIR}"

echo -e "${GREEN}✓ DMG created successfully: ${FINAL_DMG}${NC}"
echo -e "${GREEN}Size: $(du -h "${FINAL_DMG}" | cut -f1)${NC}"
