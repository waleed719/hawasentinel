# HawaSentinel Flutter App Implementation Plan

We will create a new Flutter application that connects to the Node.js backend we just built, featuring a sleek, dark-themed, agentic UI as shown in your design reference.

## User Review Required

> [!WARNING]
> **"GENUI" Package Clarification**
> You mentioned using the "flutter GENUI package". There isn't a widely standard package specifically named exactly `genui` on pub.dev that is universally used for this. I will build the "agentic" UI using standard Flutter Material components (customized for the premium dark theme in your screenshot) and handle state management with `provider`. If you have a very specific `genui` package or local library in mind, please let me know!

## Proposed Changes

### 1. Project Initialization
- Create a new Flutter project named `hawasentinel_app`.
- Add dependencies: `http` (for API calls), `provider` (for state management), `google_fonts` (for modern typography), and `fl_chart` (for analytics/surge graphs).

### 2. Core Architecture & API Integration
- **`services/api_service.dart`**: Handles communication with `http://localhost:3000/api/simulate` and `/api/aqi`.
- **`providers/app_state.dart`**: Manages the global state, holding the latest simulation data (AQI, Agent decisions, etc.).

### 3. UI Implementation (Dark Theme)
We will implement the following screens based on the provided mockup:

- **Splash Screen (`screens/splash_screen.dart`)**: A premium dark screen with the HawaSentinel logo/icon that automatically navigates to the Home screen.
- **Home Dashboard (`screens/home_screen.dart`)**: Displays the massive current AQI, quick status of the 3 active agents, and top-level alerts (matching Screen 04).
- **Agents Overview (`screens/agents_screen.dart`)**: A detailed list of the School, Hospital, and Rider agents. Tapping one expands to show their specific actions and JSON-parsed decisions (matching Screen 07/09/10/11).
- **Alerts Center (`screens/alerts_screen.dart`)**: A feed of all generated notices, hospital reallocations, and rider routing restrictions (matching Screen 08).
- **Analytics/Trends (`screens/analytics_screen.dart`)**: Uses `fl_chart` to visualize the mock AQI forecast or hospital surge predictions (matching Screen 05).

### 4. Theming
- **`theme.dart`**: Implement a global dark theme using `#0F172A` (Tailwind slate-900) as the background, with vibrant green (`#22C55E`) and red (`#EF4444`) accents for agent statuses and AQI warnings.

## Verification Plan
1. Run `flutter create hawasentinel_app`.
2. Implement the screens and API logic.
3. Run the Flutter app (Linux desktop or Android emulator) while the Node.js server is running on port 3000.
4. Verify that hitting the "Simulate" button in the app successfully triggers the local Ollama agents and updates the UI with the structured JSON responses.
