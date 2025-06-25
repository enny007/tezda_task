# Tezda Task - Flutter E-commerce App

A Flutter Ios application built with Clean Architecture, featuring authentication, product browsing, Method Channeling and favorites functionality.

## 🏗️ Architecture

This project follows **Clean Architecture** principles with clear separation of concerns:

```
lib/
├── main.dart
├── app/
│   ├── app.dart
│   └── router/
│       └── app_router.dart
├── core/
│   ├── constants/
│   │   └── app_constants.dart
│   ├── exceptions/
│   │   └── app_exceptions.dart
│   ├── utils/
│   │   └── validators.dart
│   └── widgets/
│       └── loading_widget.dart
├── features/
│   ├── auth/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── auth_remote_datasource.dart
│   │   │   ├── models/
│   │   │   │   └── user_model.dart
│   │   │   └── repositories/
│   │   │       └── auth_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── user_entity.dart
│   │   │   ├── repositories/
│   │   │   │   └── auth_repository.dart
│   │   │   └── usecases/
│   │   │       ├── login_usecase.dart
│   │   │       ├── register_usecase.dart
│   │   │       └── logout_usecase.dart
│   │   └── presentation/
│   │       ├── providers/
│   │       │   └── auth_provider.dart
│   │       ├── screens/
│   │       │   ├── login_screen.dart
│   │       │   ├── register_screen.dart
│   │       │   └── splash_screen.dart
│   │       └── widgets/
│   │           └── auth_form_field.dart
│   ├── product/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── product_remote_datasource.dart
│   │   │   ├── models/
│   │   │   │   └── product_model.dart
│   │   │   └── repositories/
│   │   │       └── product_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── product_entity.dart
│   │   │   ├── repositories/
│   │   │   │   └── product_repository.dart
│   │   │   └── usecases/
│   │   │       ├── get_products_usecase.dart
│   │   │       └── get_product_detail_usecase.dart
│   │   └── presentation/
│   │       ├── providers/
│   │       │   └── product_provider.dart
│   │       ├── screens/
│   │       │   ├── home_screen.dart
│   │       │   └── product_detail_screen.dart
│   │       └── widgets/
│   │           └── product_card.dart
│   └── favorites/
│       ├── data/
│       │   ├── datasources/
│       │   │   └── favorites_local_datasource.dart
│       │   ├── models/
│       │   │   └── favorite_model.dart
│       │   └── repositories/
│       │       └── favorites_repository_impl.dart
│       ├── domain/
│       │   ├── entities/
│       │   │   └── favorite_entity.dart
│       │   ├── repositories/
│       │   │   └── favorites_repository.dart
│       │   └── usecases/
│       │       ├── add_favorite_usecase.dart
│       │       ├── remove_favorite_usecase.dart
│       │       └── get_favorites_usecase.dart
│       └── presentation/
│           ├── providers/
│           │   └── favorites_provider.dart
│           ├── screens/
│           │   └── favorites_screen.dart
│           └── widgets/
│               └── favorite_item.dart
└── shared/
    ├── providers/
    │   └── firebase_providers.dart
    └── services/
        └── firebase_service.dart
```

## 🚀 Features

- **Authentication**: Login, Register, Profile Management
- **Product Browsing**: View products, product details
- **Favorites**: Add/remove products from favorites
- **State Management**: Riverpod for reactive state management
- **Navigation**: Go Router for declarative routing
- **Backend**: Firebase Authentication & Firestore
- **Method-Integration-With-Swift**: Used MethodChannel for platform-specific functionality

## 🛠️ Tech Stack

- **Flutter**: Cross-platform mobile development
- **Riverpod**: State management
- **Go Router**: Navigation
- **Firebase**: Authentication & Database
- **Clean Architecture**: Scalable code organization

## 📱 Getting Started

### Prerequisites

- Flutter SDK (>=3.0.0)
- Dart SDK (>=3.0.0)
- iOS Simulator / Android Emulator
- Firebase project setup

### Installation

1. Clone the repository
```bash
git clone https://github.com/enny007/tezda-task.git
cd tezda-task
```

2. Install dependencies
```bash
flutter pub get
```

3. Configure Firebase
   - Add your `google-services.json` (Android)
   - Add your `GoogleService-Info.plist` (iOS)

4. Run the app
```bash
flutter run
```

## 🏛️ Architecture Layers

### Domain Layer
- **Entities**: Core business objects
- **Repositories**: Abstract contracts
- **Use Cases**: Business logic operations

### Data Layer
- **Models**: Data transfer objects
- **Data Sources**: API/Database interactions
- **Repository Implementations**: Concrete implementations

### Presentation Layer
- **Providers**: State management
- **Screens**: UI components
- **Widgets**: Reusable UI elements

## 🔧 Configuration

### Firebase Setup
1. Create a Firebase project
2. Enable Authentication (Email/Password)
3. Create Firestore database
4. Add configuration files to respective platforms

### iOS Configuration
See [iOS Setup Guide](docs/ios-setup.md)

### Android Configuration
See [Android Setup Guide](docs/android-setup.md)

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
```

## 2. iOS Setup Documentation

```markdown:docs/ios-setup.md
# iOS Setup Guide

This guide covers the necessary configuration for running the Tezda Task app on iOS.

## Prerequisites

- Xcode 14.0 or later
- iOS 11.0 or later
- CocoaPods installed

### 2. Minimum iOS Version

Ensure minimum iOS version is set in `ios/Podfile`:

```ruby
platform :ios, '11.0'
```

### 4. Pod Installation

```bash
cd ios
pod install
cd ..
```

## Build Configuration

### 1. Bundle Identifier

Update bundle identifier in `ios/Runner.xcodeproj`:
1. Open project in Xcode
2. Select `Runner` target
3. Go to "Signing & Capabilities"
4. Update "Bundle Identifier" to match your Firebase project

### 2. Signing

Configure code signing:
1. Select your development team
2. Enable "Automatically manage signing"

## Permissions

The app requires the following permissions (already configured):

- **Internet Access**: For API calls
- **Network State**: For connectivity checks

## Running the App

### Simulator
```bash
flutter run -d ios
```

### Physical Device
1. Connect your iOS device
2. Trust the developer certificate on device
3. Run: `flutter run -d [device-id]`

## Troubleshooting

### Common Issues

1. **Pod Install Fails**
   ```bash
   cd ios
   pod repo update
   pod install --repo-update
   ```

2. **Firebase Not Initialized**
   - Verify `GoogleService-Info.plist` is in correct location
   - Check bundle identifier matches Firebase project

3. **Code Signing Issues**
   - Ensure valid development team is selected
   - Check provisioning profiles

4. **Build Errors**
   ```bash
   flutter clean
   cd ios && pod clean && pod install
   flutter run
   ```

## Additional Configuration

### App Icons
- Replace icons in `ios/Runner/Assets.xcassets/AppIcon.appiconset/`
- Use 1024x1024 for App Store icon

### Launch Screen
- Modify `ios/Runner/Base.lproj/LaunchScreen.storyboard`

### App Name
- Update `CFBundleDisplayName` in `Info.plist`

## Deployment

### TestFlight
1. Archive in Xcode
2. Upload to App Store Connect
3. Process and distribute via TestFlight

### App Store
1. Complete app metadata in App Store Connect
2. Submit for review
3. Release when approved
```

## 3. Android Setup Documentation

```markdown:docs/android-setup.md
# Android Setup Guide

This guide covers the necessary configuration for running the Tezda Task app on Android.

## Prerequisites

- Android Studio
- Android SDK (API level 21 or higher)
- Java 8 or higher

## Firebase Configuration

### 1. Add google-services.json

1. Download `google-services.json` from your Firebase project
2. Place it in `android/app/` directory

### 2. Update build.gradle files

#### Project-level build.gradle (`android/build.gradle`):
```gradle
dependencies {
    classpath 'com.google.gms:google-services:4.3.15'
}
```

#### App-level build.gradle (`android/app/build.gradle`):
```gradle
apply plugin: 'com.google.gms.google-services'

android {
    compileSdkVersion 34
    
    defaultConfig {
        minSdkVersion 21
        targetSdkVersion 34
    }
}

dependencies {
    implementation 'com.google.firebase:firebase-auth'
    implementation 'com.google.firebase:firebase-firestore'
}
```

## Permissions

Add to `android/app/src/main/AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
```

## Build Configuration

### 1. Application ID

Update `applicationId` in `android/app/build.gradle`:
```gradle
defaultConfig {
    applicationId "com.yourcompany.tezda_task"
    // ... other config
}
```

### 2. Signing Configuration

For release builds, add signing config:
```gradle
android {
    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
            storePassword keystoreProperties['storePassword']
        }
    }
    buildTypes {
        release {
            signingConfig signingConfigs.release
        }
    }
}
```

## Running the App

### Emulator
```bash
flutter run -d android
```

### Physical Device
1. Enable Developer Options and USB Debugging
2. Connect device via USB
3. Run: `flutter run -d [device-id]`

## Troubleshooting

### Common Issues

1. **Gradle Build Fails**
   ```bash
   cd android
   ./gradlew clean
   cd ..
   flutter clean
   flutter pub get
   ```

2. **Firebase Issues**
   - Verify `google-services.json` is in `android/app/`
   - Check application ID matches Firebase project

3. **SDK Issues**
   - Update Android SDK tools
   - Accept all licenses: `flutter doctor --android-licenses`

## Deployment

### Google Play Store
1. Generate signed APK/AAB
2. Upload to Google Play Console
3. Complete store listing
4. Submit for review
```

## 4. Contributing Guidelines

```markdown:CONTRIBUTING.md
# Contributing to Tezda Task

Thank you for considering contributing to Tezda Task! This document provides guidelines for contributing to the project.

## Code of Conduct

Please read and follow our [Code of Conduct](CODE_OF_CONDUCT.md).

## Getting Started

1. Fork the repository
2. Clone your fork
3. Create a feature branch
4. Make your changes
5. Submit a pull request

## Development Setup

1. Install Flutter SDK
2. Clone the repository
3. Run `flutter pub get`
4. Configure Firebase
5. Run `flutter run`

## Architecture Guidelines

### Clean Architecture Layers

- **Domain**: Business logic and entities
- **Data**: Data sources and repositories
- **Presentation**: UI and state management

### Naming Conventions

- **Files**: snake_case
- **Classes**: PascalCase
- **Variables**: camelCase
- **Constants**: UPPER_SNAKE_CASE

### Code Style

- Follow Dart style guide
- Use meaningful variable names
- Add comments for complex logic
- Write unit tests for business logic

## Pull Request Process

1. Update documentation if needed
2. Add tests for new features
3. Ensure all tests pass
4. Update CHANGELOG.md
5. Request review from maintainers

## Reporting Issues

Use GitHub Issues to report bugs or request features:

1. Check existing issues first
2. Use issue templates
3. Provide detailed information
4. Include steps to reproduce

## Questions?

Feel free to open a discussion or contact the maintainers.
```

## 5. License File

```markdown:LICENSE
MIT License

Copyright (c) 2024 Tezda Task

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

