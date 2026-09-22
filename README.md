# Food App

A Flutter food-delivery app that tracks an order through six statuses on a
Google Map, and mirrors that status to the **lock screen** — an iOS Live
Activity (ActivityKit) and an Android ongoing notification.

## Features

- **Order tracking on a map** — restaurant, rider and destination markers over
  a route polyline, with the camera following the rider
- **Six order statuses** — placed → kitchen preparing → prepared → rider picked
  up → rider on the way → delivered
- **iOS Live Activity** — lock-screen banner plus all three Dynamic Island
  presentations, with a self-animating countdown and progress bar
- **Android ongoing notification** — foreground service with a six-step
  progress bar and a countdown chronometer
- **Deep linking** — tapping either surface opens straight to the tracking
  screen via `foodapp://order/<id>`

## Architecture

Feature-based Clean Architecture with Provider for state **and** dependency
injection. See [CLAUDE.md](CLAUDE.md) for the full description and
[ORDER_TRACKING.md](ORDER_TRACKING.md) for the lock-screen implementation.

```
lib/
├── base/                 # BaseProvider / BaseUseCase / BaseDataRepository / ...
├── configs/              # R.colors, R.textStyles, common widgets, sizing
├── features/<feature>/   # data / domain / presentation / di
├── routes/               # go_router + global navigatorKey
└── services/             # api, dio, hive, internet, live_activity
```

Call flow: `View → Provider.fetchData() → UseCase → Repository → DataSource → ApiService`

## Setup

```bash
flutter pub get
```

**1. Environment file** — `.env` is gitignored but required as an asset:

```bash
cp env_example.txt .env
```

**2. Google Maps API key** — needed on both platforms, kept out of git:

```bash
# iOS
cp ios/Flutter/Secrets.example.xcconfig ios/Flutter/Secrets.xcconfig
# then replace ADD_YOUR_GOOGLE_MAP_KEY with your key

# Android — add to android/local.properties
echo "googleMapsApiKey=ADD_YOUR_GOOGLE_MAP_KEY" >> android/local.properties
```

Restrict the key in Google Cloud Console: Android by package name + SHA-1, iOS
by bundle ID.

**3. Run**

```bash
flutter run
```

## Commands

```bash
make get / clean / run / analyze / format / test
make build-apk / build-appbundle / build-ios
make create-module name=FeatureName   # scaffold a feature slice (Hygen)
```

## Requirements

- Flutter 3.47+
- iOS 16.1+ for Live Activities (the app itself targets iOS 15; the extension
  simply isn't installed below 16.1)
- Dynamic Island requires iPhone 14 Pro or newer

## Current limitations

- **Order data is simulated.** `SimulatedOrderDataSource` advances the status on
  a timer. Swap it for a real implementation in the feature's DI module — that
  one line is the only change needed.
- **Lock-screen updates stop if the app is killed.** Updates are driven by the
  app process, so the Live Activity marks itself stale ("Paused — open the app
  to resume") rather than showing a frozen status. Continuous updates on a
  locked phone require APNs push-to-Live-Activity and a server.
