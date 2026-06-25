# App Store & Play Store Release Checklist

## Pre-Release

- [ ] All features tested on physical devices
- [ ] Performance benchmarks met (< 5s translation, < 2s startup)
- [ ] Crash-free rate > 99%
- [ ] All unit and widget tests passing
- [ ] Static analysis clean (`flutter analyze`)
- [ ] Code formatted (`dart format .`)

## Google Play Store

### App Information
- [ ] App title: "Bangla Voice Translator"
- [ ] Short description (80 chars max)
- [ ] Full description (4000 chars max)
- [ ] App category: Tools > Translation
- [ ] Content rating questionnaire completed
- [ ] Privacy policy URL provided

### Graphics
- [ ] App icon: 512x512 PNG
- [ ] Feature graphic: 1024x500 PNG
- [ ] Phone screenshots: minimum 2, up to 8 (16:9 or 9:16)
- [ ] 7-inch tablet screenshots (recommended)
- [ ] 10-inch tablet screenshots (recommended)

### Technical
- [ ] Target API level meets Play Store requirements (API 34+)
- [ ] 64-bit support (arm64-v8a)
- [ ] App signing by Google Play enabled
- [ ] Upload signing key to Play Console
- [ ] AAB format (not APK) for production
- [ ] ProGuard/R8 minification enabled
- [ ] App Bundle size under 150MB

### Compliance
- [ ] Data safety form completed
- [ ] Microphone permission declaration
- [ ] Encryption declaration (uses HTTPS)
- [ ] COPPA compliance (if targeting children)
- [ ] Ads declaration (no ads)

## Apple App Store

### App Information
- [ ] App name: "Bangla Voice Translator"
- [ ] Subtitle (30 chars max)
- [ ] Description
- [ ] Keywords (100 chars max)
- [ ] Category: Utilities > Translation
- [ ] Privacy policy URL
- [ ] Support URL

### Graphics
- [ ] App icon: 1024x1024 PNG (no alpha, no rounded corners)
- [ ] iPhone 6.7" screenshots (required)
- [ ] iPhone 6.5" screenshots (required)
- [ ] iPhone 5.5" screenshots (required)
- [ ] iPad Pro 12.9" screenshots (if supporting iPad)

### Technical
- [ ] Minimum iOS version: 13.0
- [ ] Provisioning profile (distribution)
- [ ] App ID registered in Apple Developer Portal
- [ ] Push notification entitlement (if needed)
- [ ] Background audio entitlement configured
- [ ] Microphone usage description in Info.plist
- [ ] Archive built in Xcode (Release configuration)
- [ ] Uploaded via Xcode or Transporter

### Compliance
- [ ] App Privacy details completed
- [ ] Export compliance (uses standard encryption)
- [ ] Age rating questionnaire
- [ ] App Review Information (demo credentials if needed)

## Post-Release

- [ ] Monitor Crashlytics for new crashes
- [ ] Monitor Analytics for user behavior
- [ ] Respond to initial user reviews
- [ ] Plan next update based on feedback
- [ ] Document known issues
