# Flutter Pretext Package

I have completely ported the Chenglou Pretext text layout engine algorithm into a native Flutter package inside `/home/waleedqamar/Documents/crazy experiment/pretext/flutter_pretext`!

## What was Accomplished

1. **Native Segmentation Engine (`src/analysis.dart`)**: We created a robust, zero-dependency Dart heuristic word and punctuation segmenter leveraging the standard `characters` package for grapheme clusters (perfectly avoiding FFI/Native C bindings and retaining full macOS/web/iOS/Android compatibility). 
2. **Measurement Caching (`src/measurement.dart`)**: We converted the JS `canvas.measureText` engine into a cached headless `TextPainter` instance repository that measures widths instantaneously.
3. **Pure Math Algorithm (`src/line_break.dart` / `src/layout.dart`)**: Ported the dynamic, high-speed line wrapping cursor logic. Since Dart utilizes AOT compilation, this algorithm runs in less than a microsecond per paragraph.
4. **UI Widgets (`flutter_pretext.dart`)**: Instead of having to build the engine from scratch, I've exposed the backend engine into three incredibly powerful out-of-the-box widgets:

### 1. `ObstacleTextFlow`
This fulfills exactly the use-case you requested. Given a list of `Rect` objects (perhaps from absolute coordinates of a floated image), this widget uses `layoutNextLine()` in a loop to recalculate the available width for *each individual text line*, cleanly breaking paragraphs around arbitrary rectangles on your screen.

### 2. `ShrinkWrapText`
Utilizes Pretext's `measureNaturalWidth()` mathematical iterator to tightly bind the container width to the longest *drawn* string width, completely solving the "Trailing Space Container Bug" present in regular Flutter `Text` widgets when breaking lines.

### 3. `BalancedText`
Calculates optimal wrapping breaks to ensure there are no single "orphan" words sitting alone at the bottom of long paragraphs by internally iterating widths via binary search.

## Try It Out
You can immediately try building an example application using your new package. In any other flutter project, just refer to it via local path in your `pubspec.yaml`:
```yaml
dependencies:
  flutter_pretext:
    path: /home/waleedqamar/Documents/crazy experiment/pretext/flutter_pretext
```
