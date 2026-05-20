# Invoice and Ledger Updates

## Modifications Made:

1. **Invoice Status Update (Dart Layer)**:
   - Modified `updateInvoiceStatus` in `lib/features/invoices/data/datasource/invoice_remote_datasource.dart`.
   - Now, when an invoice status is changed to `paid`, the system automatically fetches the invoice details and inserts a `credit` entry into the ledger for that client.
   - This deducts the invoice amount from the client's total balance. Appropriate remarks (`'Payment received for invoice #<invoice_number>'`) are added to the transaction log.
   - Note: Invoice *generation* already included the logic to create a `debit` entry for the invoiced amount, which increases the client's balance.

2. **Order Creation Logic for Vendors (Dart Layer)**:
   - Added logic to `createOrder` in `lib/features/orders/data/datasource/order_remote_datasource.dart` so it now explicitly handles vendor ledgers.
   - When placing an order, the system calculates the procurement value and immediately inserts a `credit` ledger entry for the **Vendor**, matching typical supplier relationships.
   - It **does not** touch the client ledger, keeping our frontend codebase consistent with the requirement.

3. **Order Ledger Trigger Removal (Database Layer)**:
   - Evaluated the frontend codebase and confirmed that Flutter didn't manually insert ledger records previously, so it was handled automatically by a database trigger in Supabase (which erroneously did for clients).
   - Provided a SQL script to cleanly remove this hidden backend behavior so the explicit Dart code takes precedence.

## Actions Required

Since the legacy order-to-ledger link is driven by the database, please execute the SQL script created to stop orders from triggering indiscriminate ledger transactions on the backend.

> [!IMPORTANT]
> Please run the following script in your Supabase SQL Editor. It will drop legacy triggers, giving the Dart code full control over the ledger:
>
> **Script**: [remove_order_to_ledger_trigger.sql](file:///home/waleedqamar/Documents/ledgerly/DB/remove_order_to_ledger_trigger.sql)

Once this script is run, placing an order will correctly increase the **vendor's** ledger (handled by the app codebase now), without incorrectly altering the client's ledger balance. The client's balance will continue to only update upon **invoice generation** (debit) and **invoice payment** (credit).
