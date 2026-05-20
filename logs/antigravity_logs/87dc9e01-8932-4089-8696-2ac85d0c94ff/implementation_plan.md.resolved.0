# Adding Critical Lawyer Features

This plan outlines the required architectural and feature additions to make the application viable for selling. These additions address major usability gaps including missing notifications, missing historical context, and lack of visibility into background operations.

## User Review Required

> [!WARNING]
> This plan introduces native dependencies (notifications) and new domain entities (case notes). Please review the approaches before execution.

> [!TIP]
> This plan answers your question about how a Law Firm architecture would differ. See the "Open Questions / Context" section below for the detailed answer.

## Proposed Changes

---

### Phase 1: Hearing Notifications
To prevent missed hearing dates, we'll introduce local notifications. 

#### [MODIFY] `pubspec.yaml`
- Add `flutter_local_notifications` and `timezone` for scheduling alarms.

#### [NEW] `lib/core/services/notification_service.dart`
- Create a service to request permissions (Android 13+, iOS) and schedule notifications.
- Functions: `scheduleHearingNotification(CaseEntity case)`

#### [MODIFY] `lib/features/case_management/domain/usecases/case/create_case.dart` (and update_case.dart)
- Whenever a case is created or updated with a `nextHearingDate`, invoke the `NotificationService` to schedule alarms (e.g. 24 hours prior, 2 hours prior, and at the time).

---

### Phase 2: Notes / Activity Log & Case Status History
Every action (client meetings, calls, status changes) must be tracked.

#### [NEW] Domain Layer
- `lib/features/case_management/domain/entities/case_note_entity.dart`: Contains `id`, `caseId`, `content`, `timestamp`, `type` (e.g. user_note, status_change, document_added).
- `case_note_repository.dart` and Use Cases (`add_note.dart`, `get_notes_for_case.dart`).

#### [NEW] Data Layer
- `case_note_model.dart`
- Hive adapter and Firestore collection (`users/{uid}/case_notes`).
- Add to `repositories_impl.dart`.

#### [MODIFY] `lib/features/case_management/domain/usecases/case/update_case.dart`
- When updating a case, if `oldCase.status != newCase.status`, automatically generate a `CaseNoteEntity` of type `status_change` detailing the transition (e.g., "Status changed from Active to Appealed"). This provides the **audit trail**.

#### [NEW] Presentation Layer
- Add an "Activity Log / Notes" tab or section inside the Case Details screen showing the chronological history.

---

### Phase 3: Global Search
A unified search bar.

#### [NEW] `lib/features/case_management/domain/usecases/global_search.dart`
- A specific use case that runs queries against `CaseRepository`, `ClientRepository`, and `DocumentRepository` concurrently and aggregates the result.

#### [NEW] Presentation Layer
- `global_search_delegate.dart` or a dedicated search page that takes a query, runs `global_search.dart`, and displays categorized results (Cases matching title/number, Clients matching name/phone, Documents matching title).

---

### Phase 4: Backup Confirmation
Give the user peace of mind that their data is safe.

#### [NEW] `lib/core/providers/sync_manager_provider.dart`
- Create a Riverpod `StateNotifier` that manages the periodic execution of the existing `syncPendingCases`, `syncPendingClients`, etc.
- Track a `DateTime? lastBackupTime`.

#### [MODIFY] Presentation Layer (Settings / Dashboard)
- Bind to `syncManagerProvider`. Show "Last backed up: X minutes ago" with a green checkmark if recent (e.g. < 5 mins ago), or a sync button to manually trigger one.

---

### Phase 5: Case Number Auto-Generation
Reduce friction when creating cases.

#### [NEW] `lib/features/case_management/domain/usecases/case/generate_case_number.dart`
- Service/Usecase that looks at the user's latest case, extracts the number, and increments it (e.g., format: `{YEAR}-0001`).

#### [MODIFY] `lib/features/case_management/presentation/pages/create_case_page.dart`
- If the case number field is left blank, auto-fill it using `generate_case_number.dart` on submission, or prepopulate it when the screen opens.

---

## Open Questions / Context

### Question: "Right Now this app targets individual Lawyers. In case of Law firms what would we need to change"

To transition from an Individual Lawyer product (B2C) to a Law Firm product (B2B SaaS), you would need to implement:
1. **Multi-Tenancy & Roles**: Instead of directly linking Data to a `User` (Lawyer), Data links to a `Firm`. The `User` is then an employee of the firm with a specific role (Admin, Partner, Associate, Paralegal).
2. **Access Control & Assignment**: A system for assigning cases. You can't have an associate seeing the billing details of all partners. You also need to assign cases to specific lawyers (`assignedTo` fields) within the firm.
3. **Firm-level Billing & Invoicing**: Centralized billing systems with different hourly rates based on the lawyer's title.
4. **Shared Calendars**: A master calendar for the firm so partners can see court schedules across all associates.
5. **Team Workflows**: Task assignment (e.g., a lawyer assigning a "Draft standard motion" task to a paralegal) directly within the app.

## Verification Plan

### Automated Tests
- Test that notifications are created on expected dates.
- Test that changing a case status correctly generates a status note log.
- Test that a generated case number increments correctly.

### Manual Verification
- Deploy app on device, create a case, set a hearing date for +2 mins, and wait for the local alarm to fire.
- Update a case and check the Notes tab to ensure the status history is recorded.
- Perform a global search and verify all entity types are displayed.
- Check the UI for the "Last Backed Up" prompt.
