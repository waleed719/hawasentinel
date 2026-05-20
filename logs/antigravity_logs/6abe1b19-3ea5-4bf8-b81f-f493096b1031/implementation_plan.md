# Daily Production System (DPS) Implementation Plan

## Goal
Build a Daily Production System (DPS) module for tracking daily production reports including energy usage, production, consumption, and damage, and automatically generate inventory transactions via a Supabase RPC function.

## User Review Required
> [!IMPORTANT]
> The existing `inventory_transactions` table in `client.sql` has `quantity` as `INT`. To support the requirement of `quantity NUMERIC`, I will include an `ALTER TABLE` statement in the SQL migration to change `quantity` to `NUMERIC(12,2)`. Also, the `item_type` constraint in the DB restricts values to `PRODUCT` and `RAW_MATERIAL`, so the RPC will map the types appropriately to uppercase to match the existing schema.
> I will provide a single `.sql` file (`DB/dps_schema.sql`) for you to execute in your Supabase SQL editor.

## Proposed Changes

---

### Supabase Database & RPC

#### [NEW] [dps_schema.sql](file:///home/waleedqamar/Documents/ledgerly/DB/dps_schema.sql)
Create the required tables exactly as specified:
- `machines`
- `dps_reports`
- `dps_energy_logs`
- `dps_production_logs`
- `dps_consumption_logs`
- `dps_damage_logs`

Include an `ALTER TABLE inventory_transactions ALTER COLUMN quantity TYPE NUMERIC(12,2);` to ensure the `inventory_transactions` table meets the numeric quantity requirement.

Create a Postgres RPC function `create_dps_report(payload JSON)` that uses a transaction block (`BEGIN ... COMMIT` inside PL/pgSQL) to:
1. Insert the report and get its ID.
2. Insert energy logs, production logs, consumption logs, and damage logs from the JSON payload.
3. Insert corresponding inventory transactions.

---

### Flutter Models

#### [NEW] [dps_models.dart](file:///home/waleedqamar/Documents/ledgerly/lib/features/dps/domain/entities/dps_models.dart)
Create Freezed models for:
- `Machine`
- `DpsReport`
- `DpsEnergyLog`
- `DpsProductionLog`
- `DpsConsumptionLog`
- `DpsDamageLog`
Each with `fromJson` and `toJson` methods.

---

### Flutter Repository

#### [NEW] [dps_repository.dart](file:///home/waleedqamar/Documents/ledgerly/lib/features/dps/data/repositories/dps_repository.dart)
Implement `DpsRepository` to interact with Supabase:
- `getMachines()`
- `getReports()`
- `createReport(Map<String, dynamic> payload)` (Calls the RPC function)

---

### Riverpod State Management

#### [NEW] [dps_providers.dart](file:///home/waleedqamar/Documents/ledgerly/lib/features/dps/presentation/providers/dps_providers.dart)
Implement Riverpod providers to manage the DPS state:
- State classes for form handling (selected date, energy logs, production logs, consumption logs, damage logs).
- `dpsReportsProvider` to fetch the report list.
- `dpsMachinesProvider` to fetch machines.
- `dpsFormNotifier` to handle adding/removing rows, calculating totals, and submitting the report.

---

### Flutter UI Screens

#### [NEW] [dps_dashboard.dart](file:///home/waleedqamar/Documents/ledgerly/lib/features/dps/presentation/pages/dps_dashboard.dart)
A screen to list all DPS reports with date, status, and summary counts.

#### [NEW] [add_dps_report_page.dart](file:///home/waleedqamar/Documents/ledgerly/lib/features/dps/presentation/pages/add_dps_report_page.dart)
A complex form to add a DPS report, including sections for:
- **Energy**: Loop through machines to input operator name, gas weight, and wood weight.
- **Production**: Per-machine rows to add products and quantities.
- **Consumption**: Per-machine rows to add raw materials and quantities.
- **Damage**: Per-machine rows to record damaged products/raw materials and reasons.
- **Totals & Submit**: Display calculated totals and validate inputs before calling the RPC.

#### [MODIFY] [sidebar.dart](file:///home/waleedqamar/Documents/ledgerly/lib/sidebar.dart)
Add the DPS module to the sidebar navigation to allow the user to access the `DpsDashboard`.

## Verification Plan

### Automated Tests
- N/A - relying on manual verification as per standard workflow for Flutter.

### Manual Verification
1. Please execute the `DB/dps_schema.sql` in your Supabase SQL editor.
2. Run the Flutter app and navigate to the DPS module.
3. Submit a new DPS report with sample data across all categories.
4. Verify the report appears in the DPS dashboard.
5. Check the Supabase database to ensure the report, logs, and corresponding `inventory_transactions` were correctly created.
