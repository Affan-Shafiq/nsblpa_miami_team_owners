#!/bin/bash

# NSBLPA Miami Team Owners - Release Build Script
# This script automates the process of building a release version for Google Play Store

echo "🚀 Starting release build process..."

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter not found. Please install Flutter and add it to your PATH."
    exit 1
fi

# Get Flutter version
FLUTTER_VERSION=$(flutter --version | grep "Flutter" | head -n 1)
echo "✅ Flutter found: $FLUTTER_VERSION"

# Clean previous builds
echo "🧹 Cleaning previous builds..."
flutter clean
if [ $? -ne 0 ]; then
    echo "❌ Failed to clean project"
    exit 1
fi

# Get dependencies
echo "📦 Getting dependencies..."
flutter pub get
if [ $? -ne 0 ]; then
    echo "❌ Failed to get dependencies"
    exit 1
fi

# Check if signing.properties exists
SIGNING_FILE="android/app/signing.properties"
if [ ! -f "$SIGNING_FILE" ]; then
    echo "⚠️  Warning: $SIGNING_FILE not found. Build will use debug signing."
    echo "   Create this file with your keystore information for release signing."
else
    echo "✅ Signing configuration found"
fi

# Build app bundle
echo "🔨 Building Android App Bundle (AAB)..."
flutter build appbundle --release
if [ $? -ne 0 ]; then
    echo "❌ Failed to build app bundle"
    exit 1
fi

# Check if build was successful
OUTPUT_FILE="build/app/outputs/bundle/release/app-release.aab"
if [ -f "$OUTPUT_FILE" ]; then
    FILE_SIZE=$(du -h "$OUTPUT_FILE" | cut -f1)
    echo "✅ Build successful!"
    echo "📱 App Bundle created: $OUTPUT_FILE"
    echo "📏 File size: $FILE_SIZE"
    
    # Open the output directory (macOS)
    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo "📂 Opening output directory..."
        open -R "$OUTPUT_FILE"
    # Open the output directory (Linux)
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if command -v xdg-open &> /dev/null; then
            echo "📂 Opening output directory..."
            xdg-open "$(dirname "$OUTPUT_FILE")"
        fi
    fi
    
else
    echo "❌ Build failed - output file not found"
    exit 1
fi

echo "🎉 Release build completed successfully!"
echo "📤 You can now upload the AAB file to Google Play Console"
echo "📖 See GOOGLE_PLAY_UPLOAD_GUIDE.md for detailed upload instructions"
