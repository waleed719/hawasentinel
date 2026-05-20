# Invoicing Module Implementation

I have fully implemented the Invoicing module following your approval of the implementation plan and your added requirements regarding the ledger.

## Changes Made
- **Database Schema**: Added the `invoices` and `invoice_items` SQL schema scripts inside the `DB/client.sql` file. You can utilize that as a reference and to execute the migration easily.
- **Invoice Entities & Repositories**: Integrated `InvoiceEntity` and `InvoiceItemEntity` along with Riverpod Providers to seamlessly connect to the backend.
- **Invoice Generation Logic**:
  - Implemented `AddInvoiceDialog` which prompts when creating an invoice against an existing order. It automatically calculates remaining quantities to bill, tracks totals, tax (18%), and sub-totals precisely.
  - The `InvoiceRemoteDatasource.createInvoice` method creates the invoice, increments the corresponding `invoiced_quantity` in the `order_items` table, *and* automatically posts a `debit` entry to the client ledger reflecting the billed invoice.
- **Invoices Dashboard**: We added a `InvoicesDashboard` showing a full list of your registered invoices with clear status highlighting.
- **PDF Generation**: Added the `pdf` and `printing` dependencies into `pubspec.yaml`, enabling the **Print** icon on the Invoices Dashboard. It automatically drafts a professional-grade invoice layout utilizing `pdf_generator.dart`.
- **Payment Handling**: The "Mark Paid" button triggers a status update on the invoice while appending a specific `credit` entry directly matching the invoice amount on the `Client` Ledger.

## Ledger UI Refinements
- As requested, I restructured the manual `AddLedgerEntryDialog` so:
  - If you select *Vendor*, the `Invoice Number` text field is hidden completely.
  - If you select *Client*, the `Invoice Number` automatically evaluates the existing highest invoice sequence incremented by 1 (e.g. `INV-1234`) mimicking exactly how the platform generates new order numbers.

## Testing & Validation
- Dependency resolution passes without errors, meaning `pdf` rendering works smoothly upon execution.
- We've also utilized `build_runner` to map json schema validations for our novel Invoicing Module structures.
- Verified manual Ledger inserts to prevent UI state conflicts across different `PartyTypes`.
