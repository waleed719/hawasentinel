# Implement Invoicing Module

This plan covers adding a comprehensive Invoincing module that separates order creation from ledger updates, allows tracking partial/full deliveries through invoices, and handles automatic calculation of financials, generation of PDFs, and updating the client's ledger upon payment.

## User Review Required
> [!IMPORTANT]
> The addition of `invoices` and `invoice_items` requires changes to your Supabase schema. Please review the SQL query provided below and run it in your Supabase SQL editor before we proceed.
> Additionally, adding the capability to mark an invoice as "paid" triggers a client ledger entry. By standard accounting, when the invoice is *generated*, the client balance should increase (Debit), and when *paid*, it should decrease (Credit) showing they cleared that amount. Let me know if you want the system to insert a Debit entry when the invoice is created, and the corresponding Credit entry when paid, or strictly just a Credit when paid.

### Database Schema Updates
You will need to execute the following SQL in your Supabase project:
```sql
CREATE TABLE invoices (
  id SERIAL PRIMARY KEY,
  order_id INT REFERENCES orders(id) ON DELETE RESTRICT,
  client_id INT REFERENCES clients(id) ON DELETE RESTRICT,
  supplier_id INT REFERENCES suppliers(id) ON DELETE RESTRICT,
  invoice_number VARCHAR(50) UNIQUE NOT NULL,
  status VARCHAR(20) DEFAULT 'unpaid', -- 'paid' or 'unpaid'
  po VARCHAR(100),
  issue_date DATE NOT NULL,
  sub_total DECIMAL(12,2) NOT NULL DEFAULT 0,
  shipping_cost DECIMAL(12,2) NOT NULL DEFAULT 0,
  tax_percent DECIMAL(5,2) NOT NULL DEFAULT 18.00,
  tax_amount DECIMAL(12,2) NOT NULL DEFAULT 0,
  grand_total DECIMAL(12,2) NOT NULL DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TABLE invoice_items (
  id SERIAL PRIMARY KEY,
  invoice_id INT REFERENCES invoices(id) ON DELETE CASCADE,
  order_item_id INT REFERENCES order_items(id) ON DELETE RESTRICT,
  product_id INT REFERENCES products(id) ON DELETE RESTRICT,
  quantity INT NOT NULL,
  unit_price DECIMAL(12,2) NOT NULL,
  total_price DECIMAL(12,2) NOT NULL
);
```

## Proposed Changes

### Dependencies
#### [MODIFY] pubspec.yaml
- Add `pdf` and `printing` packages to generate standard formatted PDFs and present standard print dialogue/download operations natively.

---

### Invoices Domain & Data Layer
Create the core functionality to communicate with Supabase.

#### [NEW] lib/features/invoices/domain/entities/invoice_entity.dart
- Define the `InvoiceEntity` along with factory from json methods matching the Supabase schema above.

#### [NEW] lib/features/invoices/domain/entities/invoice_item_entity.dart
- Define the `InvoiceItemEntity` outlining relation to products, order item, quantities, and prices.

#### [NEW] lib/features/invoices/domain/repositories/invoice_repository.dart
#### [NEW] lib/features/invoices/data/repositories/invoice_repository_impl.dart
#### [NEW] lib/features/invoices/data/datasource/invoice_remote_datasource.dart
- Implement robust methods: `createInvoice()` which simultaneously inserts the invoice details and bulk-updates the `invoiced_quantity` in `order_items`.
- Provide `getInvoices()`, `getInvoiceById()`, and `updateInvoiceStatus(id, status)` methodologies.

#### [NEW] lib/features/invoices/presentation/providers/invoice_providers.dart
- Expose the riverpod states handling all fetching and saving capabilities seamlessly linked with the repository.

---

### Invoices Presentation (UI)
User interface implementation consistent with the Ledgerly dynamic schema.

#### [NEW] lib/features/invoices/presentation/pages/invoices_dashboard.dart
- Display a categorized/filterable list of all generated invoices.
- Functionality for each: **View** (opens detailed overlay), **Print** (opens system print dialog & PDF download), and **Mark as Paid**.
- **Mark as paid** action updates the invoice status to "paid" and triggers an update using `LedgerRemoteDatasource` adding the requisite entry to the client.

#### [NEW] lib/features/invoices/presentation/pages/add_invoice_dialog.dart
- Pop-up dialogue launched from the Order Dashboard for specific orders.
- UI elements include inputs for "Invoiced Quantities" mapping directly back to original unfulfilled order items.
- Visually calculates and displays the Subtotal, Shipping cost (editable), 18% GST inline, and the Grand Total.

#### [NEW] lib/features/invoices/utils/pdf_generator.dart
- Dart abstraction converting `InvoiceEntity` details into a cleanly styled multi-page PDF document format suitable for businesses.

---

### Orders Module Integrations
Embed entry points into the existing flow without changing order generation fundamentals.

#### [MODIFY] lib/features/orders/presentation/pages/order_dashboard.dart
- Add an "Invoices" navigation header layout button.
- Adjust the `_StatusPill` context menu to include a `Generate Invoice` action redirecting to `AddInvoiceDialog`.

#### [MODIFY] lib/features/orders/presentation/pages/order_details_page.dart
- Include visuals of `invoicedQuantity` out of `Total Quantity` explicitly.

## Future-proofing Evaluation
Your requirement specifies gathering more metrics for analysis software later.
- The implemented schema directly captures `shipping_cost`, `tax_amount`, and `sub_total` independently off items granting detailed fiscal insights.
- The tracking of `order_item_id` inherently traces which shipments partially fulfilled larger orders. This enables tracking vendor efficiency and shipping rates across multi-invoice deliveries in future analytic iterations.

## Open Questions
1. Regarding ledger entries: Currently your client ledger has debit = increasing what they owe, credit = decreasing. Normally, writing an invoice creates a Debit entry (they owe you the invoice amount). Upon paying, it creates a Credit entry. Do you want the system to create **two** ledger entries mechanically (one debit on save, one credit on 'paid') or **one** ledger entry solely on the `paid` event?
2. Has the Supabase schema execution script above been successfully executed on your database? Ensure you run it.

## Verification Plan

### Automated Tests
- Static checks using `dart format` and `dart analyze`.
- Package resolve executions guaranteeing `pdf` integration.

### Manual Verification
- We will visually generate an Invoice pointing to a specific prior Order, asserting the total correctly reflects math encompassing partial unit assignments, shipping and exactly 18% GST.
- Generating PDF file.
- "Mark Paid" trigger correctly injecting a ledger entry on the Client account with 'auto recorded from $invoice' terminology correctly integrated.
