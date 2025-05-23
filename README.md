# Kite

[![style: very good analysis][very_good_analysis_badge]][very_good_analysis_link]

---

Kagi Flutter Demo Project

<table width="100%">
    <tr>
        <td><img src="screenshots/Stories-List.png" alt="Stories list"></td>
        <td><img src="screenshots/Story1.png" alt="Story details"></td>
        <td><img src="screenshots/Story2.png" alt="Story details"></td>
    </tr>
    <tr>
        <td><img src="screenshots/Story4.png" alt="Stories details"></td>
        <td><img src="screenshots/Story5.png" alt="Story details"></td>
        <td><img src="screenshots/Story6.png" alt="Story details"></td>
    </tr>
    <tr>
        <td><img src="screenshots/Today-events.png" alt="Stories details"></td>
        <td><img src="screenshots/Today-people.png" alt="Story details"></td>
    </tr>
</table>

### [Demo Video](https://youtube.com/shorts/mcNZ09ZB7yE)

## Getting Started 🚀

* [Install the Flutter SDK](https://docs.flutter.dev/get-started/install). You will additionally need to install the Android or iOS SDK depending on which platform(s) you intend to build for. The Flutter installation documentation includes instructions for setting up those SDKs.

*  Once Flutter is installed clone this repo and run `flutter pub get` to install dependencies before running Kite.

## Running Kite

This project contains 3 flavors:

- development
- staging
- production

To run the desired flavor either use the launch configuration in VSCode/Android Studio or use the following commands:

```sh
# Development
$ flutter run --flavor development --target lib/main_development.dart

# Staging
$ flutter run --flavor staging --target lib/main_staging.dart

# Production
$ flutter run --flavor production --target lib/main_production.dart
```

### A signed release build of Kite for Android is included in this repo. To install, copy `kite.apk` to an Android device and use a file browser to install or use `adb install kite.apk` to install to a device with developer mode enabled. To use Kite on an iOS device you will have to use one of the `flutter run` commands above. 

---

## Running Tests 🧪

To run all unit and widget tests use the following command:

```sh
$ flutter test --coverage --test-randomize-ordering-seed random
```

To view the generated coverage report you can use [lcov](https://github.com/linux-test-project/lcov).

```sh
# Generate Coverage Report
$ genhtml coverage/lcov.info -o coverage/

# Open Coverage Report
$ open coverage/index.html
```

---

## Working with Translations 🌐

This project relies on [flutter_localizations][flutter_localizations_link] and follows the [official internationalization guide for Flutter][internationalization_link].

### Adding Strings

1. To add a new localizable string, open the `app_en.arb` file at `lib/l10n/arb/app_en.arb`.

```arb
{
    "@@locale": "en",
    "counterAppBarTitle": "Counter",
    "@counterAppBarTitle": {
        "description": "Text shown in the AppBar of the Counter Page"
    }
}
```

2. Then add a new key/value and description

```arb
{
    "@@locale": "en",
    "counterAppBarTitle": "Counter",
    "@counterAppBarTitle": {
        "description": "Text shown in the AppBar of the Counter Page"
    },
    "helloWorld": "Hello World",
    "@helloWorld": {
        "description": "Hello World Text"
    }
}
```

3. Use the new string

```dart
import 'package:kite/l10n/l10n.dart';

@override
Widget build(BuildContext context) {
  final l10n = context.l10n;
  return Text(l10n.helloWorld);
}
```

### Adding Supported Locales

Update the `CFBundleLocalizations` array in the `Info.plist` at `ios/Runner/Info.plist` to include the new locale.

```xml
    ...

    <key>CFBundleLocalizations</key>
	<array>
		<string>en</string>
		<string>es</string>
	</array>

    ...
```

### Adding Translations

1. For each supported locale, add a new ARB file in `lib/l10n/arb`.

```
├── l10n
│   ├── arb
│   │   ├── app_en.arb
│   │   └── app_es.arb
```

2. Add the translated strings to each `.arb` file:

`app_en.arb`

```arb
{
    "@@locale": "en",
    "counterAppBarTitle": "Counter",
    "@counterAppBarTitle": {
        "description": "Text shown in the AppBar of the Counter Page"
    }
}
```

`app_es.arb`

```arb
{
    "@@locale": "es",
    "counterAppBarTitle": "Contador",
    "@counterAppBarTitle": {
        "description": "Texto mostrado en la AppBar de la página del contador"
    }
}
```

### Generating Translations

To use the latest translations changes, you will need to generate them:

1. Generate localizations for the current project:

```sh
flutter gen-l10n --arb-dir="lib/l10n/arb"
```

Alternatively, run `flutter run` and code generation will take place automatically.

[flutter_localizations_link]: https://api.flutter.dev/flutter/flutter_localizations/flutter_localizations-library.html
[internationalization_link]: https://flutter.dev/docs/development/accessibility-and-localization/internationalization
[very_good_analysis_badge]: https://img.shields.io/badge/style-very_good_analysis-B22C89.svg
[very_good_analysis_link]: https://pub.dev/packages/very_good_analysis
