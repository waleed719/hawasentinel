# Decouple Flutter from Core Engine

- [ ] Create `lib/src/font.dart` (Abstract `Font` interface)
- [ ] Create `lib/src/text_style_font.dart` (Flutter implementation)
- [ ] Refactor `lib/src/measurement.dart` to remove Flutter dependency
- [ ] Refactor `lib/src/layout.dart` to use `Font` instead of `TextStyle`
- [ ] Update `lib/src/widgets/obstacle_text_flow.dart` 
- [ ] Update `lib/src/widgets/shrink_wrap_text.dart`
- [ ] Update `lib/src/widgets/balanced_text.dart`
- [ ] Export new Font classes in `lib/flutter_pretext.dart`
- [ ] Update tests in `test/flutter_pretext_test.dart`
- [ ] Bump version to `1.1.0` in `pubspec.yaml` and `CHANGELOG.md`
- [ ] Verify build and tests
