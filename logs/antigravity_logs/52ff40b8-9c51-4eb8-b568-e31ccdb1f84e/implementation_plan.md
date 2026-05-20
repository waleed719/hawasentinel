# Goal Description
The goal is to replace the current "puzzles" used in the active portion of the App (the `AnalyticalPhasePage`) with three completely new games requested by the user:
1. Memory Grid
2. Word Scramble
3. Reaction Test

Per the user's request, no existing games will be deleted. Their widgets will remain in the codebase, but their imports will be removed from the phase page where they are currently used, so they no longer appear in the app.

## Proposed Changes
We will create three new game widget files in the `puzzles` folder and then hook them up in the `analytical_phase_page.dart`. These widgets will be built natively in Flutter without external assets, using shapes, animations, and text for a visually pleasing and interactive experience.

### Puzzles
#### [NEW] [memory_grid_game.dart](file:///run/media/waleedqamar/New%20Volume/flutterprojects/mind_forge/lib/presentation/widgets/puzzles/memory_grid_game.dart)
This game will present a grid of varying sizes (based on difficulty). A pattern of tiles will light up for a brief period, and the user must tap those exact tiles to win.

#### [NEW] [word_scramble_game.dart](file:///run/media/waleedqamar/New%20Volume/flutterprojects/mind_forge/lib/presentation/widgets/puzzles/word_scramble_game.dart)
A word unscrambling game where the user must arrange jumbled letters to form the correct word within a specific time or attempt limit.

#### [NEW] [reaction_test_game.dart](file:///run/media/waleedqamar/New%20Volume/flutterprojects/mind_forge/lib/presentation/widgets/puzzles/reaction_test_game.dart)
A timing game where the screen prompts the user to "Wait...", and upon changing color or signal to "TAP NOW!", the user must tap as quickly as possible. The reaction time determines the success rating.

### Analytical Phase Page
#### [MODIFY] [analytical_phase_page.dart](file:///run/media/waleedqamar/New%20Volume/flutterprojects/mind_forge/lib/presentation/pages/phases/analytical_phase_page.dart)
- Remove `LightsOutGame` and `SequenceDecoderGame` imports.
- Import the three new games.
- Update the randomly selected active puzzle to be one of these three new options.

## Verification Plan
### Manual Verification
- Once implemented, the user can manually test the active calculation card on the Analytical Phase page.
- We will ensure it compiles without errors and effectively selects one of the three new puzzles randomly. Each game will properly log its score upon completion.
