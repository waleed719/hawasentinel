# Abstracting Flutter from Core Core Architecture

## Goal
Decouple the core pretext geometry algorithms from Flutter's `TextStyle` and `TextPainter`. This allows the pure-Dart calculation engine to be utilized universally (e.g., in `pdf` generators, sheer Dart servers, simple web projects without Flutter, etc.). The existing Flutter wrappers (`ObstacleTextFlow`, etc.) will continue to seamlessly use a new `TextStyleFont` implementation wrapper without degrading the developer experience.

## Proposed Changes

### 1. `lib/src/font.dart` [NEW]
* Define an abstract, pure-Dart interface `Font` requiring a single `double measureWidth(String seg);` method.

### 2. `lib/src/measurement.dart` [MODIFY]
* Remove `import 'package:flutter/widgets.dart';`.
* Change caching from `<TextStyle, Map...>` to `<Font, Map...>`, relying on custom `==` and `hashCode`.
* Strip out `TextPainter`; instead internally invoke `font.measureWidth(seg)`.
* Change signatures (`getSegmentMetrics`, `getSegmentGraphemeWidths`, etc.) to accept `Font` instead of `TextStyle`.

### 3. `lib/src/layout.dart` [MODIFY]
* Remove `import 'package:flutter/widgets.dart';`.
* Update `prepare()` signature to accept abstract `Font` instead of `TextStyle`. 

### 4. `lib/src/text_style_font.dart` [NEW]
* Implement the Flutter-specific wrapper: `class TextStyleFont extends Font`.
* Construct a `TextPainter`, layout strings securely, cache against `TextSpan`, and crucially, call `painter.dispose()` afterward to protect native memory pools as noted by the Reddit feedback.
* Add an explicit, controllable `TextDirection` argument to support Right-To-Left tracking.
* Properly implement `==` and `hashCode` by evaluating the underlying `TextStyle` and `TextDirection`.

### 5. `lib/src/widgets/*` [MODIFY]
* Update existing Flutter widgets (`ObstacleTextFlow`, `ShrinkWrapText`, `BalancedText`, etc.) to transparently wrap incoming `TextStyle`s with `TextStyleFont` before pushing them into the core parser.

### 6. `lib/flutter_pretext.dart` [MODIFY]
* Export `Font` and `TextStyleFont` so power users can use them natively.

## User Review Required

> [!WARNING]
> Because the method signature of `prepare()` is changing from `prepare(text, TextStyle)` to `prepare(text, Font)`, this is technically a breaking change if anyone had adopted the standalone `prepare()` function manually in version `1.0.1`. Should I explicitly bump the version to `2.0.0` or `1.1.0` in `pubspec.yaml`?

## Verification Plan
1. **Automated Tests**: Alter `test/flutter_pretext_test.dart` to adopt `TextStyleFont`. Execute tests ensuring core measurement widths haven't geometrically shifted.
2. **Manual Verification**: Run the example app checking if the Custom Shapes, Shrink Wraps, and dynamic boundaries still compile identically.
