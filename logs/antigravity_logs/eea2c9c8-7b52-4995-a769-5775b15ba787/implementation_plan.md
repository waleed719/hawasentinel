# Knowledge Phase Update with In-App Cards

The goal of this update is to keep the user engaged within the app during the Knowledge Phase. Instead of instructing the user to leave the app to research a topic, we will present concise, knowledge-dense content via a swipeable card interface. After reviewing the cards, the user will be asked to summarize their key takeaways in 3 points, with at least 1 point being compulsory.

## User Review Required

> [!IMPORTANT]
> - **Package Selection**: You mentioned using `flutter_carousel`. The most widely used community package for this is `carousel_slider` (or `flutter_carousel_widget`). Unless you specify otherwise, I will use `carousel_slider`.
> - **Content Generation**: I will update the existing topics in `knowledge_content.dart` to include a `cards` list with generated educational content for each topic. Please confirm if this is okay.

## Proposed Changes

---

### Data Layer Updates

#### [MODIFY] knowledge_content.dart
- Update the `topicsByLevel` to include a `cards` array (e.g., `List<String>`) for each topic.
- Each string in the array will represent one concise, short knowledge card related to that topic (I will use AI to generate thoughtful, dense content for the existing topics).

#### [MODIFY] local_content_service.dart
- Ensure `generateTopicBrief` returns the new `cards` data so it can be consumed by the UI.

---

### Presentation Layer Updates

#### [MODIFY] pubspec.yaml
- Run `flutter pub add carousel_slider` to add the required dependency for the swipeable cards.

#### [MODIFY] knowledge_phase_page.dart
- **UI Structure**: Replace the "Research, Synthesize, Internalize" instructions with a beautifully styled `CarouselSlider`.
- **Carousel Design**: Each card will have a rich gradient/design, displaying the specific knowledge bite cleanly and concisely.
- **Summary Section**: 
  - Reduce the `TextEditingController` list from 6 to 3.
  - Update the validation logic so that only **1 point** is compulsory (must have >= 10 characters to be valid) instead of 3.
  - The score calculation will be updated to reflect the 3 points (e.g., `(qualityPoints / 3) * 100`).

## Open Questions

> [!WARNING]
> Please answer the following before I proceed:
> 1. Should I use the `carousel_slider` package for the swipeable cards?
> 2. Should the 3 summary input fields be visible immediately below the carousel, or should they only appear *after* the user has swiped to the last card?
> 3. Are you okay with me generating the content for the cards for the existing topics in `knowledge_content.dart`?

## Verification Plan

### Automated Tests
- N/A for this UI and data swap, though I'll ensure `dart analyze` passes.

### Manual Verification
- Run the app and enter the Knowledge Phase.
- Verify the cards are displayed properly and are swipeable.
- Verify that attempting to complete the phase with 0 filled inputs shows an error.
- Verify that filling 1 input properly allows completing the phase and saves the result.
