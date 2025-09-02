# Google Play Store Upload Guide

This guide will help you prepare and upload your NSBLPA Miami Team Owners app to the Google Play Store.

## Prerequisites

1. **Google Play Console Account**: You need a Google Play Console developer account ($25 one-time fee)
2. **App Bundle (AAB)**: Google Play Store requires Android App Bundle format
3. **Signed APK/AAB**: Your app must be digitally signed with a release keystore
4. **Privacy Policy**: Required for apps that collect user data
5. **App Content Rating**: Must complete content rating questionnaire

## Step 1: Generate Release Keystore

### Option A: Using Android Studio
1. Open Android Studio
2. Go to **Build** → **Generate Signed Bundle / APK**
3. Select **Android App Bundle**
4. Click **Create new** to create a new keystore
5. Fill in the required information:
   - **Key store path**: Choose a secure location
   - **Password**: Create a strong password
   - **Alias**: Create a key alias
   - **Key password**: Create a strong key password
6. Save the keystore file as `upload-keystore.jks` in the `android/` directory

### Option B: Using Command Line
```bash
keytool -genkey -v -keystore upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

## Step 2: Configure Signing

1. **Update `android/app/signing.properties`**:
   ```properties
   storeFile=../upload-keystore.jks
   storePassword=YOUR_KEYSTORE_PASSWORD
   keyAlias=YOUR_KEY_ALIAS
   keyPassword=YOUR_KEY_PASSWORD
   ```

2. **Replace placeholder values** with your actual keystore information

3. **Keep this file secure** - never commit it to version control

## Step 3: Build Release Bundle

### Clean Build
```bash
flutter clean
flutter pub get
```

### Build App Bundle
```bash
flutter build appbundle --release
```

The generated AAB file will be located at:
`build/app/outputs/bundle/release/app-release.aab`

## Step 4: Google Play Console Setup

### 1. Create New App
1. Go to [Google Play Console](https://play.google.com/console)
2. Click **Create app**
3. Fill in app details:
   - **App name**: NSBLPA Miami Team Owners
   - **Default language**: English
   - **App or game**: App
   - **Free or paid**: Free (or Paid if applicable)

### 2. App Information
- **App name**: NSBLPA Miami Team Owners
- **Short description**: Brief description (80 characters max)
- **Full description**: Detailed description (4000 characters max)
- **Category**: Sports (or appropriate category)

### 3. App Content
- **Content rating**: Complete the questionnaire
- **Target audience**: Select appropriate age groups
- **Content descriptors**: Mark if applicable

### 4. Privacy Policy
- **Privacy policy URL**: Required if collecting user data
- **Data safety**: Complete data safety section

## Step 5: Upload App Bundle

### 1. Production Track
1. Go to **Production** → **Create new release**
2. Click **Upload** and select your AAB file
3. Add **Release notes** (what's new in this version)
4. Click **Save**

### 2. Internal Testing Track (Recommended First)
1. Go to **Testing** → **Internal testing**
2. Create new release with your AAB
3. Add testers by email
4. Test thoroughly before production

### 3. Closed Testing Track
1. Go to **Testing** → **Closed testing**
2. Create new release with your AAB
3. Add testers by email or Google Groups
4. Test with larger group

## Step 6: Store Listing

### 1. Graphics
- **Feature graphic**: 1024 x 500 px
- **App icon**: 512 x 512 px
- **Screenshots**: At least 2, up to 8 per device type
  - Phone: 16:9 or 9:16 ratio
  - 7-inch tablet: 16:9 or 9:16 ratio
  - 10-inch tablet: 16:9 or 9:16 ratio

### 2. Content
- **App description**: Clear, compelling description
- **What's new**: Release notes for updates
- **Keywords**: Relevant search terms

## Step 7: Release to Production

### 1. Review Process
- Google Play reviews typically take 1-3 days
- Ensure all required information is complete
- Check for policy compliance

### 2. Publish
- Click **Review release**
- Confirm all information is correct
- Click **Start rollout to Production**

## Important Notes

### Security
- **Never share your keystore file or passwords**
- **Keep backup of keystore** - losing it means you can't update your app
- **Store keystore securely** - consider password manager or secure storage

### Updates
- **Version code must increase** with each update
- **Version name** should be user-friendly (e.g., "1.0.1")
- **Update release notes** for each version

### Compliance
- **Follow Google Play policies** strictly
- **Test thoroughly** before release
- **Monitor crash reports** and user feedback

## Troubleshooting

### Common Issues

1. **Upload failed**: Check AAB file size and format
2. **Signing issues**: Verify keystore configuration
3. **Policy violations**: Review Google Play policies
4. **Rejection**: Address feedback and resubmit

### Build Issues

1. **ProGuard errors**: Check `proguard-rules.pro` file
2. **Dependency conflicts**: Update dependencies in `pubspec.yaml`
3. **Memory issues**: Increase Gradle memory in `gradle.properties`

## Support Resources

- [Google Play Console Help](https://support.google.com/googleplay/android-developer)
- [Flutter Documentation](https://flutter.dev/docs)
- [Android Developer Documentation](https://developer.android.com/)

## Next Steps After Upload

1. **Monitor analytics** in Google Play Console
2. **Respond to user reviews** promptly
3. **Plan regular updates** to maintain user engagement
4. **Consider beta testing** for major features
5. **Monitor crash reports** and performance metrics

---

**Remember**: The first upload is the most critical. Take your time to ensure everything is correct, as changes after publication can affect your app's visibility and user trust.
