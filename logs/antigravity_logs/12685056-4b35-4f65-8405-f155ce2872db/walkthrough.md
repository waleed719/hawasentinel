# Raw Material Refactor & Unified Inventory Implementation

## What Was Accomplished

The raw material module has been completely decoupled from the products module, and both have been unified under a shared inventory transactions layer.

1. **Unified Database Schema**: Replaced the hard-coded `inventory_transactions` table with a unified schema using `item_id`, `item_type` (`'PRODUCT'` or `'RAW_MATERIAL'`), and added forward-compatible reference columns.
2. **Shared Core Inventory**: Extracted all shared logic into a new `core/inventory` feature, containing a cross-module `InventoryRepository` that acts as a single point of truth for all manual inventory ins/outs.
3. **Raw Material Refactor**: We completely overhauled `features/raw_material/`. It now has its own domain models, data layers, providers, and detail/dashboard UI implementations separate from the products feature, solving previously shared types.
4. **Product Integration**: Cleaned the `features/products/` module and removed the duplicated inventory layer, seamlessly wiring the previous inventory tracking through the new `core`.

> [!TIP]
> The database changes fully position you for analytics. We have an integrated table structure that BI tools like PowerBI can seamlessly hook into to determine stock levels via grouping `item_id` and summing `quantity`.

## Validation

- **Compiled successfully**: `build_runner` completed the regeneration of data classes.
- **Analyzed successfully**: Flutter analyzer passing. Deprecation warnings for `DropdownButtonFormField` were resolved.
- **App Consistency**: Both Products and Raw Materials components now have the `IN` and `OUT` UI operations successfully routing to the single shared repository.

## Future Plans Supported

The schema already supports columns for `reference_id` and `reference_type`. When modules like Procurement or Customer Orders are built, they can emit transactions natively here.
