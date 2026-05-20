# Document Feature Implementation

This plan outlines the architecture and steps needed to implement the document tab in the case details page. `file_picker` and `syncfusion_flutter_pdfviewer` have already been added to the project.

## User Review Required

Since `firebase_storage` is not in your project, this plan assumes **local-only** document storage for the MVP. File paths will be saved to the local Hive cache and mapped to specific cases. If the user clears the app cache or uninstalls, the files might be lost unless we back them up to Firebase Storage. 

Please review the Open Questions down below before approving!

## Proposed Changes

---

### Data and Domain Layer (New Models & Repositories)
We need a data structure to store the documents tied to a case.
#### [NEW] `lib/features/case_management/domain/entities/document_entity.dart`
- Create `DocumentEntity` containing `id`, `caseId`, `name`, `localPath`, and `attachedAt`.
#### [NEW] `lib/features/case_management/data/models/document_model.dart`
- Create `DocumentModel` with `fromHive` / `toHive`. (Will leave Firestore empty/stubbed since we are doing local files only for now).
#### [MODIFY] `lib/features/case_management/data/datasource/data_source.dart`
- Introduce `DocumentLocalDataSource` interface.
#### [NEW] `lib/features/case_management/data/datasource/document_local_datasource.dart`
- Implement Hive storage for storing document metadata.
#### [NEW] `lib/features/case_management/data/repositories/document_repository_impl.dart`
- Implement the repository handling the document operations.

---

### Application Layer (Providers & Use Cases)
#### [NEW] `lib/features/case_management/domain/usecases/document/get_documents_for_case.dart`
- Fetches all Documents for a specific `caseId`.
#### [NEW] `lib/features/case_management/domain/usecases/document/attach_document.dart`
- Attaches a new document record.
#### [NEW] `lib/features/case_management/domain/usecases/document/delete_document.dart`
- Deletes a document record.
#### [NEW] `lib/features/case_management/presentation/providers/document_notifier.dart`
- StateNotifier (`@riverpod`) managing the list of documents for `caseId` and interacting with use cases.

---

### Presentation Layer (UI)
#### [MODIFY] `lib/features/case_management/presentation/pages/case_detail_page.dart`
- Update `_DocumentsTab` to watch `documentProvider` and show a list of saved documents.
- Implement the Floating Action Button to call `FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['pdf'])`.
- Upon successful pick, copy the file to the app's local document directory (requires `path_provider` package) and save the document via `documentProvider`.
- When a user taps a document in the list, navigate to the new PDF viewer page.
#### [NEW] `lib/features/case_management/presentation/pages/pdf_viewer_page.dart`
- A new screen utilizing `syncfusion_flutter_pdfviewer` `SfPdfViewer.file(...)` to securely display the local PDF.
#### [MODIFY] `lib/core/navigation/app_routes.dart`
- Register `PdfViewerPage` route in GoRouter.

## Open Questions

> [!IMPORTANT]
> 1. **Cloud Storage**: Do you intend to upload these PDF documents to the cloud (e.g. Firebase Storage) so they sync across devices? If so, we should add the `firebase_storage` package before beginning. For now, I've planned an offline-first, local storage model for files. Is local-only acceptable for now?
> 2. **File Types**: `syncfusion_flutter_pdfviewer` only supports PDFs. Do you want to restrict file picking exclusively to `.pdf`, or do you want to support images (`.jpg`, `.png`) as well (which would be viewed through a standard `Image.file` widget)?
> 3. **Dependencies**: We will need the `path_provider` package to safely copy the selected files into the app's persistent storage directory so they aren't lost when Android/Linux clears cache directories. Shall I run `flutter pub add path_provider`?

## Verification Plan

### Automated Tests
- `flutter analyze` and `flutter test` to ensure no syntactical errors introduced.

### Manual Verification
- Launch the application using `flutter run -d linux`.
- Navigate to a Case -> Documents tab.
- Click "Add Document", select a local PDF file.
- Validate that the file appears in the list.
- Click the file in the list and ensure the `SfPdfViewer` successfully renders the PDF file contents.
