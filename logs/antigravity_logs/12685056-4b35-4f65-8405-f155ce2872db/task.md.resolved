# Task: Raw Material Refactor + Unified Inventory

## Phase 1: Database Schema
- [x] Update `DB/client.sql` with new inventory_transactions schema + fix raw_material table

## Phase 2: Shared Core Inventory Layer
- [x] `lib/core/inventory/domain/entities/inventory_transaction_entity.dart`
- [x] `lib/core/inventory/domain/repositories/inventory_repository.dart`
- [x] `lib/core/inventory/data/datasource/inventory_remote_datasource.dart`
- [x] `lib/core/inventory/data/repositories/inventory_repository_impl.dart`
- [x] `lib/core/inventory/presentation/providers/inventory_providers.dart`
- [x] `lib/core/inventory/presentation/providers/inventory_providers.g.dart` (via build_runner)

## Phase 3: Raw Material Module — Full Rewrite
- [x] `domain/entities/raw_material_entity.dart` (rename + new fields)
- [x] `domain/repositories/raw_material_repository.dart` (rename)
- [x] `data/datasource/raw_material_remote_datasource.dart` (rename + price field)
- [x] `data/repositories/raw_material_repository_impl.dart` (rename)
- [x] Delete old inventory datasource/repo from raw_material (replaced by core)
- [x] `presentation/providers/raw_material_providers.dart` (own providers, no products imports)
- [x] `presentation/pages/raw_material_dashboard.dart` (proper labels/fields)
- [x] `presentation/pages/raw_material_detail_page.dart` (use core inventory)
- [x] `presentation/pages/add_raw_material_dialog.dart` (price field)

## Phase 4: Products Module — Inventory Layer Update
- [x] `domain/entities/inventory_transaction_entity.dart` (new schema fields)
- [x] `domain/repositories/product_inventory_repository.dart` (updated signatures)
- [x] `data/datasource/inventory_remote_datasource.dart` (item_id + item_type)
- [x] `data/repositories/product_invevtory_repository_impl.dart` (updated calls)
- [x] `presentation/providers/product_providers.dart` (updated signatures)
- [x] `presentation/pages/product_detail_page.dart` (notes vs remarks)
- [x] `presentation/pages/product_dashboard.dart` (notes vs remarks)

## Phase 5: Build & Verify
- [x] Run `flutter pub run build_runner build --delete-conflicting-outputs`
- [x] Run `flutter analyze`
