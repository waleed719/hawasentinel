# Write Test Cases for Data and Domain Layer

The goal is to write comprehensive unit tests for the Data and Domain layers of the `case_management` feature based on your request.

## User Review Required

> [!IMPORTANT]
> The project currently lacks a mocking library (like `mockito` or `mocktail`). I propose adding `mocktail` to `dev_dependencies` to facilitate mocking Repositories and Data Sources, which simplifies setting up unit tests. `mocktail` is preferred because it works securely without requiring code generation.

## Proposed Changes

We will cover both the Domain and Data layers with targeted unit tests, ensuring business logic, mapping, and repository orchestrations function as expected and edge cases are handled.

### Dependencies

#### [MODIFY] pubspec.yaml
- Add `mocktail` to `dev_dependencies`.

---

### Domain Layer

We will test Entities for basic business logic (like `isOpen` and `isHearingOverDue` properties) and Test Use Cases by ensuring they call the Repository accurately.

#### [NEW] test/features/case_management/domain/entities/case_entity_test.dart
- Test valid entity creation.
- Test `isOpen` logic based on active/appealed/pending statuses.
- Test `isHearingOverDue` logic with past dates vs active cases.
- Test object equality and `copyWith`.

#### [NEW] test/features/case_management/domain/usecases/case_usecases_test.dart
- Group tests for `get_all_cases`, `create_case`, `update_case`, `delete_case`, `sync_pending_cases`, and `get_case_by_id`.
- Use a mock CaseRepository and verify right repository methods are invoked when use cases are executed.

#### [NEW] test/features/case_management/domain/usecases/client_usecases_test.dart
- Group testing for all generic client-related use cases against mocked repositories.

---

### Data Layer

We will write unit tests to ensure that parsing, remote-vs-local priority logic, and exceptions mappings are functioning perfectly.

#### [NEW] test/features/case_management/data/models/case_model_test.dart
- Verify `fromFirestore` and `toFirestore` maps exactly match and exclude local sync flags.
- Verify `fromHive` and `toHive` include the sync flags (like `isDirty`, `isDeletedLocally`).

#### [NEW] test/features/case_management/data/repositories/repositories_impl_test.dart
- Thorough testing over the implementation.
- Mock both `LocalDataSource` and `RemoteDataSource`.
- Test successful local + remote syncing behavior.
- Test offline-fallback behaviors (when remotes fail, use local).

#### [NEW] test/features/case_management/data/datasource/local_datasource_impl_test.dart
- Will use a mock `Hive` box setup (if possible without initializing a real hive environment on unit test runs) or wrap standard behaviors cleanly.

#### [NEW] test/features/case_management/data/datasource/remote_datasource_impl_test.dart
- Mock Firebase Firestore instances or verify standard mappings passed down to basic remote handlers.

## Open Questions

1. **Mocking Library:** Are you comfortable with me adding `mocktail` to the `dev_dependencies` for these tests?
2. **Hive Testing:** For testing LocalDataSource with Hive, would you prefer mocking the Hive interface, or initializing in-memory tests for `hive_flutter`?

## Verification Plan

### Automated Tests
- I will run `flutter test` upon completion.
- Verify all added unit tests compile and run properly.
