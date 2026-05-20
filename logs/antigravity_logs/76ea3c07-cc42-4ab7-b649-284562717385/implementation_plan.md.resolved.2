# Implement Vendor Presentation Layer

This plan outlines the creation of the `VenderDashboardView` and `AddVenderDialog` utilizing the UI patterns and CRUD flow established in the Client module.

## User Review Required
> [!WARNING]
> Because you requested the Vendor module act similarly to the Clients module (with full CRUD operations, potentially including active/inactive status and similar views), I plan to add the `isActive` parameter to `VenderEntity`. 
>
> **Action Required**: 
> You will need to manually add an `is_active` (boolean, default: true) column to your `venders` table in Supabase just like you did for clients!

## Proposed Changes

### Domain & Data Updates
#### [MODIFY] `lib/features/vender/domain/entities/vender_entity.dart`
- Add `// ignore: invalid_annotation_target` and `@JsonKey(name: 'is_active', defaultValue: true) required bool isActive,` to the factory to support state toggles.

#### [COMMAND] `dart run build_runner build -d`
- Regenerate the provider and model mapping files.

### Presentation Updates
#### [MODIFY] `lib/features/vender/presentation/providers/vender_providers.dart`
- Add an enum `VenderFilter { all, active, inactive }`.
- Insert a `@riverpod class VenderFilterNotifier` to act identically to the Client filtering.

#### [NEW] `lib/features/vender/presentation/pages/add_vender_dialog.dart`
- Create a UI form mapped to `AppColors` for taking inputs: `venderName`, `companyName`, `contactNumber`, `venderAddress`, `venderNotes`.
- Support an `isActive` toggle.
- Accept an optional `VenderEntity? venderToEdit` parameter to support "Update" actions natively. Call `addVender` or `updateVender` accordingly.

#### [NEW] `lib/features/vender/presentation/pages/vender_dashboard_view.dart`
- Build the Dashboard layout inspired by your provided screenshot and our existing application theme.
- **Header**: "Vendors" and "Manage payables and supplier relationships."
- **Summary Cards**: Add placeholder widgets "Total Outstanding" and "Upcoming in 30 Days" wrapped in matching UI to the image. (These will be hard-coded placeholders for now pending actual invoice integrations).
- **Filters**: Copy the Pill tab filter `All Vendors`, `Active`, `Inactive`.
- **List Items**: Loop over `getAllVendersProvider`.
  - Icon block with generic initials.
  - Vender Name & Company Name context.
  - Mock financial constraints (Balance Due, Last Payment).
  - Trailing `PopupMenuButton` allowing `Edit` and `Mark Inactive`.

### Main Navigation
#### [MODIFY] `lib/sidebar.dart`
- Replace `const Center(child: Text('Venders Module'))` with `const VenderDashboardView()`.

## Verification Plan
1. Check `dart analyze lib/`.
2. Wait for confirmation of `dart run build_runner build -d` to ensure generation hooks work cleanly.
