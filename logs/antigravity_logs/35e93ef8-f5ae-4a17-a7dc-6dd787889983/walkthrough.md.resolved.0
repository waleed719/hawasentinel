# Workspace Split & RTL Support Walkthrough

## How RTL Layout Works Internally

Before walking through the codebase changes, here's a brief on how the core logic actually handles Arabic (RTL) right-to-left layout constraints successfully:

1. **Logical Order vs Visual Order**: `pretext` focuses solely on string *algorithms*. The Dart `characters` library splits strings into grapheme clusters. For Arabic strings, the characters are read in memory in **logical order** (first character is logically first). The `pretext` algorithm measures and breaks lines perfectly using logical progression.
2. **Abstracted Measurement**: Because string width measurement is fully pushed out to the `Font` interface (like our `TextStyleFont`), when `pretext` asks "how wide is this Arabic string?", the underlying `TextPainter` seamlessly calculates the correct bidirectional ligature widths natively.
3. **Visual Final Rendering**: The `pretext` logic yields sequential chunks of text. When these chunks are fed back to Flutter's native `TextPainter` (in `ShrinkWrapText` and `ObstacleTextFlow`), the native renderer takes care of visually displaying the RTL text bounds. 
> [!NOTE] 
> In `ObstacleTextFlow`, we pass the exact substring back into the `TextPainter`, enabling it to natively reverse the RTL string correctly inside the exact obstacle boundaries calculated by our algorithm!

## Architectural Changes

We have successfully migrated the repository into a state-of-the-art mono-repo architecture that serves both ecosystems!

### 1. `dart_pretext` 
- **Pure Dart Code**: We created the `dart_pretext/` directory and moved `layout.dart`, `measurement.dart`, `font.dart`, and `analysis.dart` inside. Its `pubspec.yaml` specifies exactly zero Flutter dependencies!
- **Pure Dart Unit Tests**: Re-wrote the mathematical behavior testing locally inside `dart_pretext/test/layout_test.dart` using standard `test` and the simulated `MockFont`.
- **Standalone `pdf.dart` Server Example**: Inside `dart_pretext/example/`, I wrote an example that creates an A4 PDF and uses our `pretext` engine with a custom `PdfFontAdapter` to dynamically wrap strings and output to a `pretext_demo.pdf` file purely on the Dart VM!

### 2. `flutter_pretext`
- **Dependency Wrapper**: The library now locally depends on `dart_pretext: path: ./dart_pretext`.
- **Export Seamlessness**: Our `lib/flutter_pretext.dart` automatically exports `package:dart_pretext/dart_pretext.dart` along with all the widgets like `ObstacleTextFlow`. Flutter users experience literally zero friction compared to before!
- **Arabic Demo**: Created `example/lib/arabic_demo.dart` which demonstrates an Arabic string rendering natively and fully respecting right-to-left directional flags while wrapping around dynamic obstacles geometry.
