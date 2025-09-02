# NSBLPA Miami Team Owners - Release Build Script
# This script automates the process of building a release version for Google Play Store

Write-Host "🚀 Starting release build process..." -ForegroundColor Green

# Check if Flutter is installed
try {
    $flutterVersion = flutter --version
    Write-Host "✅ Flutter found: $($flutterVersion | Select-String 'Flutter' | Select-Object -First 1)" -ForegroundColor Green
} catch {
    Write-Host "❌ Flutter not found. Please install Flutter and add it to your PATH." -ForegroundColor Red
    exit 1
}

# Clean previous builds
Write-Host "🧹 Cleaning previous builds..." -ForegroundColor Yellow
flutter clean
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Failed to clean project" -ForegroundColor Red
    exit 1
}

# Get dependencies
Write-Host "📦 Getting dependencies..." -ForegroundColor Yellow
flutter pub get
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Failed to get dependencies" -ForegroundColor Red
    exit 1
}

# Check if signing.properties exists
$signingFile = "android/app/signing.properties"
if (-not (Test-Path $signingFile)) {
    Write-Host "⚠️  Warning: $signingFile not found. Build will use debug signing." -ForegroundColor Yellow
    Write-Host "   Create this file with your keystore information for release signing." -ForegroundColor Yellow
} else {
    Write-Host "✅ Signing configuration found" -ForegroundColor Green
}

# Build app bundle
Write-Host "🔨 Building Android App Bundle (AAB)..." -ForegroundColor Yellow
flutter build appbundle --release
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Failed to build app bundle" -ForegroundColor Red
    exit 1
}

# Check if build was successful
$outputFile = "build/app/outputs/bundle/release/app-release.aab"
if (Test-Path $outputFile) {
    $fileSize = (Get-Item $outputFile).Length / 1MB
    Write-Host "✅ Build successful!" -ForegroundColor Green
    Write-Host "📱 App Bundle created: $outputFile" -ForegroundColor Green
    Write-Host "📏 File size: $([math]::Round($fileSize, 2)) MB" -ForegroundColor Green
    
    # Open the output directory
    Write-Host "📂 Opening output directory..." -ForegroundColor Yellow
    Start-Process "explorer.exe" -ArgumentList "/select,$outputFile"
    
} else {
    Write-Host "❌ Build failed - output file not found" -ForegroundColor Red
    exit 1
}

Write-Host "🎉 Release build completed successfully!" -ForegroundColor Green
Write-Host "📤 You can now upload the AAB file to Google Play Console" -ForegroundColor Green
Write-Host "📖 See GOOGLE_PLAY_UPLOAD_GUIDE.md for detailed upload instructions" -ForegroundColor Cyan
