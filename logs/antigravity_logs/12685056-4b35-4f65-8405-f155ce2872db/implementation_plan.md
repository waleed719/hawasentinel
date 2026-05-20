# Raw Material Module Refactor + Unified Inventory Transactions

## Overview

The raw_material module was copy-pasted from the products module and is currently tangled — it still imports from `features/products` instead of owning its own code, and both modules use an old `inventory_transactions` table that has `product_id` hard-coded (making it impossible to track raw material stock).

The goal is to:
1. **Properly isolate** the raw_material module (its own entity, repo, providers — no cross-imports from products).
2. **Migrate both modules** to the new unified `inventory_transactions` schema that uses `item_id + item_type` instead of `product_id`.
3. **Rename raw_material fields** so they match the new DB table (`price` instead of `weight`).
4. **Update DB schema** file to reflect the migration.
5. **Future-proof for BOM / Invoices** by designing the layers to accept `referenceType` / `referenceId`.

---

## User Review Required

> [!IMPORTANT]
> The raw_material DB table currently has a `price` column (not `weight`). The raw_material entity in code uses `weight` (copy of product). You need to decide:
> - Should the raw_material have a `price` field (cost per unit)?
> - Or keep `weight`?
>
> **My plan assumes `price` as per your DB schema.**

> [!WARNING]
> The existing `inventory_transactions` table (with `product_id`) **must be dropped and replaced** by the new unified schema. You will need to run a migration in Supabase before the app works. The new SQL is included in this plan.

> [!IMPORTANT]
> The current products module also has a `weight` field. If `weight` is a product-specific concept that doesn't apply to raw materials, the separation into two entities makes sense. The plan keeps `ProductEntity` as-is and creates a separate `RawMaterialEntity`.

---

## Proposed Changes

### Database Migration

#### [MODIFY] [client.sql](file:///home/waleedqamar/Documents/ledgerly/DB/client.sql)

Replace old `inventory_transactions` table (L19-L28) with the new unified schema:

```sql
-- Drop old table
DROP TABLE IF EXISTS inventory_transactions;

-- New unified table
CREATE TABLE inventory_transactions (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    item_id BIGINT NOT NULL,
    item_type VARCHAR(20) NOT NULL CHECK (item_type IN ('PRODUCT', 'RAW_MATERIAL')),
    transaction_type VARCHAR(3) NOT NULL CHECK (transaction_type IN ('IN', 'OUT')),
    quantity INT NOT NULL CHECK (quantity > 0),
    reference_type VARCHAR(20),  -- 'PROCUREMENT', 'PRODUCTION', 'SALE', 'INVOICE', 'BOM'
    reference_id BIGINT,
    notes TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_inv_tx_item ON inventory_transactions(item_id, item_type);
CREATE INDEX idx_inv_tx_ref  ON inventory_transactions(reference_type, reference_id);
```

Also update `raw_material` table: change `price double` → `price double precision` (SQL syntax fix).

---

### Shared/Core Inventory Layer (`lib/core/inventory/`)

A single shared inventory datasource and repository handles `inventory_transactions` for **both** products and raw materials — routing via the `item_type` discriminator.

#### [NEW] `lib/core/inventory/domain/entities/inventory_transaction_entity.dart`

```dart
class InventoryTransactionEntity {
  final int id;
  final int itemId;
  final String itemType;       // 'PRODUCT' | 'RAW_MATERIAL'
  final String transactionType; // 'IN' | 'OUT'
  final int quantity;
  final String? referenceType; // 'PROCUREMENT' | 'PRODUCTION' | 'SALE' | 'INVOICE' | 'BOM'
  final int? referenceId;
  final String? notes;
  final DateTime createdAt;
}
```

#### [NEW] `lib/core/inventory/domain/repositories/inventory_repository.dart`

Abstract contract for inventory operations — used by both products and raw_material.

#### [NEW] `lib/core/inventory/data/datasource/inventory_remote_datasource.dart`

Queries `inventory_transactions` filtering by `item_id` AND `item_type`.

#### [NEW] `lib/core/inventory/data/repositories/inventory_repository_impl.dart`

Implements the abstract contract.

#### [NEW] `lib/core/inventory/presentation/providers/inventory_providers.dart`

Riverpod providers for the shared inventory layer (`inventoryRepositoryProvider`, `inventoryTransactionsByItemProvider(itemId, itemType)`, etc.)

---

### Raw Material Module — Full Replacement

All files in `raw_material` are replaced. No more cross-imports from `products`.

#### [MODIFY] `lib/features/raw_material/domain/entities/raw_material_entity.dart`  
*(currently named `product_entity.dart` — will rename)*

New `RawMaterialEntity` with fields matching DB:
- `id`, `name`, `price` (double), `description`, `createdAt`

#### [MODIFY] `lib/features/raw_material/domain/repositories/raw_material_repository.dart`
*(currently `product_repository.dart`)*

Renamed abstract class `RawMaterialRepository` with CRUD for `RawMaterialEntity`.

#### [MODIFY] `lib/features/raw_material/data/datasource/raw_material_remote_datasource.dart`
*(currently `product_remote_datasource.dart`)*

Queries `raw_material` table with proper field names (`price` not `weight`).

#### [MODIFY] `lib/features/raw_material/data/repositories/raw_material_repository_impl.dart`

Implements `RawMaterialRepository`.

#### [DELETE] `raw_material` inventory datasource/repo files  
*(replaced by the shared core inventory layer)*

#### [MODIFY] `lib/features/raw_material/presentation/providers/raw_material_providers.dart`
*(currently `product_providers.dart`)*

Providers for raw material CRUD. Inventory providers come from `core/inventory`.

#### [MODIFY] `lib/features/raw_material/presentation/pages/raw_material_dashboard.dart`
*(currently `product_dashboard.dart`)*

Updated to use `RawMaterialEntity`, correct labels ("Raw Materials", "Price" instead of "Weight").

#### [MODIFY] `lib/features/raw_material/presentation/pages/raw_material_detail_page.dart`
*(currently `product_detail_page.dart`)*

Use shared inventory providers with `itemType = 'RAW_MATERIAL'`.

#### [MODIFY] `lib/features/raw_material/presentation/pages/add_raw_material_dialog.dart`
*(currently `add_product_dialog.dart`)*

Updated form to use `price` field instead of `weight`.

---

### Products Module — Inventory Layer Update

The products module keeps its own entity/repo/datasource for product CRUD, but its **inventory operations** now delegate to the shared core inventory layer.

#### [MODIFY] `lib/features/products/data/datasource/inventory_remote_datasource.dart`

Updated to use new schema: `item_id + item_type='PRODUCT'` instead of `product_id`.

#### [MODIFY] `lib/features/products/domain/entities/inventory_transaction_entity.dart`

Updated to match new schema fields (`itemId`, `itemType`, `referenceType`, `referenceId`, `notes`).

#### [MODIFY] `lib/features/products/domain/repositories/product_inventory_repository.dart`

Signatures updated to drop old `remarks` (renamed to `notes`).

#### [MODIFY] `lib/features/products/data/repositories/product_invevtory_repository_impl.dart`

Updated to call datasource with new field names.

#### [MODIFY] `lib/features/products/presentation/providers/product_providers.dart`

Updated to reflect new entity/repo field names.

#### [MODIFY] Product detail page and dashboard pages

Updated to use `notes` instead of `remarks`, and new entity field names.

---

## Future-Proofing for BOM & Invoices

The `reference_type` and `reference_id` columns allow future modules to link transactions:
- **Sale Invoice**: `reference_type='SALE', reference_id=<invoice_id>`
- **Purchase/Procurement**: `reference_type='PROCUREMENT', reference_id=<purchase_id>`
- **Bill of Materials**: `reference_type='BOM', reference_id=<bom_id>`

The shared inventory repository will accept optional `referenceType` and `referenceId` params (default null) so existing code doesn't break when those modules are added.

---

## Analytics Question — Answer for Client

> *"Will the current database system and how much data we have support analysis with external software?"*

**Yes, Supabase/PostgreSQL is well-suited for analytics:**

| Factor | Details |
|---|---|
| **Database** | PostgreSQL — industry-standard, supported by virtually all analytics tools (Tableau, Power BI, Metabase, Grafana, etc.) |
| **Direct connection** | Supabase exposes a direct Postgres connection string for read-only analytics queries |
| **Row Level Security** | Can create a read-only analytics role with no write access |
| **Scale** | Postgres handles tens of millions of rows easily for transactional analytics |
| **New schema** | `item_type` + `reference_type` columns allow time-series analysis: stock history by product type, procurement vs. production flows, etc. |
| **Export** | CSV/JSON exports available directly from Supabase dashboard |

**Recommendation**: When data volume grows, consider enabling **Supabase's pg_analytics** extension (powered by DuckDB) for OLAP-style queries directly in the same database. For external tools, provide a read-only Postgres connection string.

---

## Verification Plan

### Automated Build Check
```bash
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
flutter analyze
```

### Manual Verification
1. Run the app and navigate to Products → verify stock IN/OUT still works
2. Navigate to Raw Materials → verify CRUD (add/edit/delete)
3. Record a stock transaction for a raw material and verify it appears correctly
4. Confirm `inventory_transactions` table in Supabase has correct `item_type` values

