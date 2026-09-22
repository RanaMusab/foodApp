# CLAUDE.md

Guidance for Claude Code (claude.ai/code) when working in this repository.

## Project Overview

Food App is a Flutter application built on feature-based Clean Architecture
with Provider for state management and dependency injection. The architecture
is ported from the GoFusion app, minus Firebase and localization.

## Development Commands

```bash
make get          # flutter pub get
make clean        # flutter clean
make run          # run on connected device
make analyze      # flutter analyze
make format       # dart format .
make test         # flutter test
make build-apk    # release APK
make build-appbundle
make build-ios    # release iOS (no codesign)
make release      # clean → get → analyze → format → build android & ios

make create-module name=FeatureName   # scaffold a full feature slice (Hygen)
```

`create-module` needs Hygen: `npm i -g hygen` (or run `npx hygen generator
mobile FeatureName`).

## Architecture

### Feature-Based Clean Architecture

```
lib/features/{feature_name}/
├── data/
│   ├── data_sources/     # the only layer that talks HTTP (via ApiService)
│   ├── models/           # extend entities, add fromJson/toJson
│   └── repository/       # repository implementations
├── domain/
│   ├── entities/         # immutable, framework-free domain types
│   │   └── params/       # request params, extend BaseRequestParam
│   ├── repository/       # repository interfaces
│   └── usecases/         # one business action each
├── presentation/
│   ├── provider/         # state, extends BaseProvider
│   ├── view/             # screens, extend BaseScreen
│   └── widgets/          # feature-local widgets
└── di/{feature}_module.dart
```

Call flow: `View → Provider.fetchData() → UseCase.call() → Repository →
DataSource → ApiService`.

### Existing Features

- `splash` — bootstrap: restores the session from Hive, routes onward
- `home` — reference slice, wired end to end

### Core Components

**Dependency Injection (`lib/injector.dart`)**
Providers *are* the service locator. Each feature exports a
`{feature}Module` list; spread it into the `MultiProvider` in `Injector`.
Adding a feature = create the module file + add one line to `injector.dart`.

`BaseUseCase` and `BaseDataRepository` resolve their dependency in their
constructor via `appContext().read()`, which reads the global `navigatorKey`.
That is why a use case can call `repository.x()` with no wiring, and why
`AppRoutes.router` must own `navigatorKey`.

**Navigation (`lib/routes/app_routes.dart`)**
`go_router`, deep-link ready. Each screen declares its own
`static const String route`; register it in `AppRoutes.router`.
`getContext()` / `appContext()` expose the root context globally.

**Base Classes (`lib/base/`)**
- `BaseProvider` — `fetchData()` wraps every API call: connectivity check,
  global loader, status-code handling (200/201 success; 301/401 auth;
  501 server), retry-from-snackbar, `onSuccess` / `onError`
- `BaseUseCase<REPO, REQUEST, RETURN>`
- `BaseDataRepository<DATASOURCE>`
- `BaseScreen<Widget, Provider>` — exposes `viewModel`, `gotoScreen`, `goBack`
- `BaseResponse` — maps `{status, message, code, result}`; `data` is `result`
- `BaseRequestParam` — carries `cancelPreviousRequests`

**API Service (`lib/services/api_service.dart`)**
Singleton over Dio. `get()` / `post()` / `put()` / `delete()` / `postFile()`.
Tokens injected from `Singleton.header` / `Singleton.headerNoAuth`; pass
`addToken: false` for public endpoints. Set `ApiService.onUnauthenticated`
once an auth feature exists so a 401 can clear state and route to login.

**Resources (`lib/configs/resources/`)**
Everything through `R`: `R.colors`, `R.assets`, `R.textStyles`, `R.strings`,
`R.boxDecoration`, `R.inputDecoration`. Screen scaling extensions live in
`sizing.dart`: `16.w`, `12.h`, `14.sp`, `20.hBox`, `8.wBox`.

**Endpoints** live in `lib/configs/resources/const/api_const.dart`. Nothing
else builds a URL.

### State Management Pattern

1. Provider extends `BaseProvider`, holds UI state, calls use cases
2. Use case = one business action
3. Repository abstracts the data source
4. Data source calls `ApiService`

### App Restart

`AppWrapper.restart(context)` regenerates the `Injector` key, rebuilding every
provider — the logout / full-reset path.

## Environment Configuration

`.env` (git-ignored; `env_example.txt` is the template):

```
baseUrlDev = https://dev-api.example.com/api/v1/
baseUrlStg = https://staging-api.example.com/api/v1/
baseUrlRelease = https://api.example.com/api/v1/
```

Read via `Environment.dev` / `.stg` / `.prod`. `ApiConfig.baseUrl` currently
points at `Environment.dev`.

## Local Storage

`HiveService` (`lib/services/hive_service.dart`) — `read` / `write` / `delete`
/ `clear`. Keys are declared in the `HiveKeys` mixin in the same file.
Initialized in `main()`.

## Code Generation

`make create-module name=FeatureName` generates the full slice (entity, params,
model, data source + impl, repository + impl, use case, provider, view, DI
module). Templates: `_templates/generator/mobile/`. After generating, spread the
new module in `lib/injector.dart` and register the view's route.

## Not Yet Set Up

- Firebase / push notifications
- Localization (strings in `R.strings` are plain English)
- Fonts (`AppTextStyles.fontFamily` is null until one is added to `pubspec.yaml`)
- Flavors — the `run-dev` / `run-staging` / `run-prod` Makefile targets need
  `lib/main_dev.dart` etc. and platform flavor config before they will run
