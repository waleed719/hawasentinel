# Update Ledger Details and Invoice Auto-completion

This plan outlines the changes required to update the ledger table format, add transaction detail dialogs, and automate the order completion status upon full invoicing.

## Proposed Changes

### Ledger Details Page
The ledger table will be reformatted, and an "info" action button will be added to view transaction details dynamically.

#### [MODIFY] [ledger_details_page.dart](file:///home/waleedqamar/Documents/ledgerly/lib/features/ledger/presentation/pages/ledger_details_page.dart)
- Update the table columns and headers to: `Date | Credit | Debit | Balance | Remarks`.
- In the `Remarks` column, conditionally render an `IconButton` before the remark text if `transactionSource` is `invoice`, `receipt`, or `disbursement`.
- Implement an `onPressed` handler for the info button that:
  - For `invoice`: Fetches the invoice details and opens an invoice view dialog.
  - For `receipt` or `disbursement`: Opens a payment details dialog showing bank title, payment name/method, date, and amount.

#### [NEW] [invoice_view_dialog.dart](file:///home/waleedqamar/Documents/ledgerly/lib/features/invoices/presentation/widgets/invoice_view_dialog.dart)
- Extract the `_InvoiceViewDialog` currently located inside `invoices_dashboard.dart` to a shared widget file so it can be reused in the ledger details page.

#### [NEW] [payment_view_dialog.dart](file:///home/waleedqamar/Documents/ledgerly/lib/features/receipts/presentation/widgets/payment_view_dialog.dart)
- Create a new dialog to display payment details (Bank Title, Name, Date, Amount) when a user inspects a receipt or disbursement from the ledger.

#### [MODIFY] [invoices_dashboard.dart](file:///home/waleedqamar/Documents/ledgerly/lib/features/invoices/presentation/pages/invoices_dashboard.dart)
- Update the dashboard to use the newly extracted `InvoiceViewDialog` widget instead of the private inline class.

### Order Auto-completion
When a user invoices the remaining quantity of an order, the order will automatically be marked as completed.

#### [MODIFY] [add_invoice_dialog.dart](file:///home/waleedqamar/Documents/ledgerly/lib/features/invoices/presentation/pages/add_invoice_dialog.dart)
- In the `_submit` method, calculate if the invoiced quantity fulfills the entire remaining quantity for all items.
- If all items are fully invoiced, dispatch an update via `orderRepositoryProvider` to change the order `status` to `completed`.

## Verification Plan

### Automated/Manual Verification
- Open a client's ledger and confirm the table columns map exactly to `Date | Credit | Debit | Balance | Remarks`.
- Click the "i" button on an invoice ledger entry and ensure the invoice view dialog opens properly.
- Click the "i" button on a receipt ledger entry and ensure the payment details dialog opens.
- Go to an order, click "Generate Invoice", set the invoiced quantity to match the remaining quantity for all items, and save. Verify the order status automatically updates to "Completed".
