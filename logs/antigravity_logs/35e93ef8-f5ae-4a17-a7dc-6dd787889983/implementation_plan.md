# Dart-Only Verification & Enhancement Plan

## User Review Required

Ah, I understand perfectly now! You want the published package to provide Flutter widgets to Flutter users, BUT also be usable purely in Dart (by servers, CLI tools, etc.).

There is a hard technical constraint in Dart's package manager (`pub`): **A single package cannot be installed by a pure Dart project if it lists `flutter: sdk: flutter` in its `pubspec.yaml`.** Even if the pure Dart user only imports `lib/src/layout.dart`, the `dart pub get` command will immediately fail saying the Flutter SDK is missing.

To achieve your exact goal of supporting BOTH ecosystems while still distributing the widgets, the standard industry practice (used by `bloc`/`flutter_bloc`, `provider`, etc.) is to split the project into **two packages** within the same repository:

**Option 1: The Multi-Package Workspace (Recommended)**
1. We create a `dart_pretext` directory (a pure Dart package perfectly clean of Flutter).
2. We keep the `flutter_pretext` package (Flutter pkg) which adds the widgets (`ShrinkWrapText`, etc.) and seamlessly `export`s the `dart_pretext` core library. 
- *Result:* Dart-only developers install `dart_pretext`. Flutter developers install `flutter_pretext` (which gives them both the core algorithm AND the widgets).

**Option 2: Just leave it as a single Flutter package**
We revert back, keep the Flutter SDK dependency, and put the widgets back in `flutter_pretext.dart`. You can still run the "pure dart logic" internally *as long as* the runtime environment has Flutter installed. (True pure-dart users won't be able to install it though).

## Proposed Changes (Assuming Option 1)

### 1. Create `dart_pretext` Core Package
#### [NEW] `dart_pretext/pubspec.yaml`
- Setup as a pure Dart package (no flutter dependency).
#### [NEW] `dart_pretext/lib/...`
- Move all core algorithms (`layout.dart`, `measurement.dart`, `font.dart`, `analysis.dart`, etc.) into this package.

### 2. Update `flutter_pretext` Package
#### [MODIFY] `flutter_pretext/pubspec.yaml`
- Add a path dependency to `dart_pretext`.
#### [MODIFY] `flutter_pretext/lib/flutter_pretext.dart`
- Export the widgets as usual, AND `export 'package:dart_pretext/dart_pretext.dart';`.

### 3. Validation & Examples
- Write pure `dart test` checks in the `dart_pretext` package.
- Write the `pdf.dart` Dart-only example in `dart_pretext/example/`.
- Keep the Flutter examples (including the new Arabic example) in `flutter_pretext/example/`.

## Open Questions

If Option 1 (the multi-package split) sounds like the perfect solution to achieve your dual-target goal, please approve this plan and I will set up the monorepo workspace for you! If you prefer Option 2, just let me know and we'll scratch the true Dart-only requirement.
## Verification Plan

### Automated Tests
- Run `dart test` to ensure tests execute purely on the Dart VM without `flutter test`.
- Ensure there are no compilation errors when importing the package into a pure Dart project.

### Manual Verification
- Generate a `.pdf` file via the new example and verify its visual layout.
- Run the Arabic text example to ensure `characters` and `layout` engine correctly handle the RTL content.
