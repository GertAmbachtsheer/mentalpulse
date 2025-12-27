---
description: How to create and publish a new GitHub release for MentalPulse
---

Follow these steps to build your app and publish a new release that the update manager can detect.

### 1. Update Version
Open `pubspec.yaml` and increment the version number.
- Example: `version: 1.0.1+2` (The update manager compares the version string before the `+`).

### 2. Build the App
Run the build command for your target platform.
- **Android APK:**
  ```bash
  flutter build apk --release
  ```
- **Windows:**
  ```bash
  flutter build windows --release
  ```

### 3. Commit and Tag
Tagging the commit is essential for GitHub releases.
```bash
git add .
git commit -m "chore: release v1.0.1"
git tag v1.0.1
git push origin main
git push origin v1.0.1
```

### 4. Create GitHub Release
Use the GitHub CLI (`gh`) to create the release and upload the build artifact.

- **For Android APK:**
  ```bash
  gh release create v1.0.1 build/app/outputs/flutter-apk/app-release.apk --title "MentalPulse v1.0.1" --notes "Add your release notes here."
  ```

- **For Windows:**
  ```bash
  gh release create v1.0.1 build/windows/runner/Release/metalpulse.exe --title "MentalPulse v1.0.1" --notes "Add your release notes here."
  ```

> [!TIP]
> The update manager specifically looks for the `tag_name` (e.g., `v1.0.1`). Ensure the version in `pubspec.yaml` matches the tag name (without the 'v').
