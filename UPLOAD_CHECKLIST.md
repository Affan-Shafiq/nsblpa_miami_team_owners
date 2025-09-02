# Google Play Store Upload Checklist

Use this checklist to ensure your app is ready for Google Play Store upload.

## Pre-Build Checklist

- [ ] **Flutter SDK**: Latest stable version installed
- [ ] **Dependencies**: All packages are up to date (`flutter pub upgrade`)
- [ ] **Code Review**: App has been tested thoroughly
- [ ] **Version Numbers**: Updated in `android/app/build.gradle.kts`
  - [ ] `versionCode` increased
  - [ ] `versionName` updated
- [ ] **App Icon**: High-quality icon (512x512 px)
- [ ] **App Name**: Final name confirmed
- [ ] **Package Name**: Confirmed as `com.nsblpa.miami`

## Build Configuration

- [ ] **ProGuard Rules**: `proguard-rules.pro` file created and configured
- [ ] **Signing Configuration**: `signing.properties` file configured
- [ ] **Keystore File**: `upload-keystore.jks` created and secured
- [ ] **Build Types**: Release configuration properly set up
- [ ] **Minification**: ProGuard/R8 enabled for release builds

## Build Process

- [ ] **Clean Build**: `flutter clean` executed
- [ ] **Dependencies**: `flutter pub get` executed
- [ ] **Release Build**: `flutter build appbundle --release` successful
- [ ] **Output File**: AAB file generated successfully
- [ ] **File Size**: AAB file size is reasonable (< 150MB recommended)
- [ ] **Signing**: AAB file is properly signed

## Google Play Console Setup

- [ ] **Developer Account**: Google Play Console account created ($25 fee paid)
- [ ] **App Created**: New app entry created in Play Console
- [ ] **App Information**: Basic app details filled out
- [ ] **Content Rating**: Content rating questionnaire completed
- [ ] **Privacy Policy**: Privacy policy URL provided (if collecting data)
- [ ] **Data Safety**: Data safety section completed

## Store Listing Assets

- [ ] **Feature Graphic**: 1024x500 px image created
- [ ] **App Icon**: 512x512 px icon uploaded
- [ ] **Screenshots**: At least 2 screenshots per device type
  - [ ] Phone screenshots (16:9 or 9:16 ratio)
  - [ ] 7-inch tablet screenshots (if targeting tablets)
  - [ ] 10-inch tablet screenshots (if targeting tablets)
- [ ] **App Description**: Compelling description written
- [ ] **Short Description**: Brief description (80 characters max)
- [ ] **Keywords**: Relevant search terms included

## Testing

- [ ] **Internal Testing**: App tested with internal team
- [ ] **Closed Testing**: App tested with selected external users
- [ ] **Bug Fixes**: All critical issues resolved
- [ ] **Performance**: App performs well on target devices
- [ ] **Compliance**: App follows Google Play policies

## Upload Process

- [ ] **AAB File**: Correct version uploaded
- [ ] **Release Notes**: What's new section filled out
- [ ] **Rollout**: Release started to production
- [ ] **Review**: Google Play review process initiated

## Post-Upload

- [ ] **Monitoring**: Play Console analytics enabled
- [ ] **Crash Reports**: Crash reporting configured
- [ ] **User Feedback**: Plan for responding to reviews
- [ ] **Update Plan**: Strategy for future updates

## Security & Compliance

- [ ] **Keystore Backup**: Keystore file securely backed up
- [ ] **Passwords**: Keystore passwords securely stored
- [ ] **Policy Compliance**: App follows all Google Play policies
- [ ] **Content Guidelines**: App content is appropriate
- [ ] **Data Handling**: User data is handled responsibly

## Final Review

- [ ] **All Checklists**: All items above completed
- [ ] **Team Review**: Final review with team members
- [ ] **Legal Review**: Legal requirements met (if applicable)
- [ ] **Marketing**: Marketing materials ready for launch

---

## Quick Commands

```bash
# Clean and build
flutter clean
flutter pub get
flutter build appbundle --release

# Check build output
ls -la build/app/outputs/bundle/release/

# Run build script (if available)
./build_release.sh  # Linux/macOS
# or
.\build_release.ps1 # Windows
```

## Important Notes

- **Never share your keystore file or passwords**
- **Keep backup of keystore** - losing it means you can't update your app
- **Test thoroughly** before release
- **Follow Google Play policies** strictly
- **Monitor crash reports** and user feedback after release

## Support

- [Google Play Console Help](https://support.google.com/googleplay/android-developer)
- [Flutter Documentation](https://flutter.dev/docs)
- [Android Developer Documentation](https://developer.android.com/)

---

**Status**: [ ] Ready for Upload | [ ] In Progress | [ ] Completed
**Last Updated**: [Date]
**Next Review**: [Date]
