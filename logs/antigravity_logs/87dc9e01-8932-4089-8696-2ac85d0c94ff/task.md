# Implementation Tracking: Critical Lawyer Features

- `[/]` Phase 1: Hearing Notifications
  - `[ ]` Add `flutter_local_notifications` and `timezone` to `pubspec.yaml`.
  - `[ ]` Implement `lib/core/services/notification_service.dart`.
  - `[ ]` Update `create_case.dart` and `update_case.dart` to schedule notifications for hearings.

- `[ ]` Phase 2: Notes / Activity Log & Case Status History
  - `[ ]` Create `CaseNoteEntity` and `CaseNoteModel`.
  - `[ ]` Create data sources, repositories, and use cases for notes.
  - `[ ]` Update `update_case.dart` to automatically log case status changes.
  - `[ ]` Create Presentation Layer UI (Timeline/Notes tab in Case Details).

- `[ ]` Phase 3: Global Search
  - `[ ]` Create `GlobalSearchUseCase`.
  - `[ ]` Create standard Search UI allowing attorneys to search "Ahmed" and see Clients, Cases, and Documents.

- `[ ]` Phase 4: Backup Confirmation
  - `[ ]` Create `SyncManagerProvider` spanning existing repositories.
  - `[ ]` Add "Last backed up" UI with timestamp and checkmark.

- `[ ]` Phase 5: Case Number Auto-Generation
  - `[ ]` Implement `GenerateCaseNumber` use case.
  - `[ ]` Update `CreateCasePage` to pre-populate or auto-generate case numbers.
