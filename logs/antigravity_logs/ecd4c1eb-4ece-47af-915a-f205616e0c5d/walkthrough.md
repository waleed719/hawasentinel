# Ledger Layout & Invoice Auto-Completion

I've completed the implementation exactly as planned. Here is a summary of the updates:

### 1. Ledger Table Reformatting
The Ledger table in `LedgerDetailsPage` has been fully redesigned to match your desired format:
- **Columns**: `Date | Credit | Debit | Balance | Remarks`
- Credits are highlighted in green, debits in red, and the balance reflects the correct ongoing total dynamically.

### 2. Transaction Details Dialog
You will now see a small blue "info" `(i)` icon in the `Remarks` column for any ledger entry that originates from an invoice, receipt, or disbursement. 
- **Invoices**: Clicking the icon will load the full `InvoiceViewDialog`, showing all the line items, totals, client/supplier details, and the "dispatched" status.
- **Payments (Receipts/Disbursements)**: Clicking the icon will load a new `PaymentViewDialog`. It displays the payment name, bank title (or payment mode), date, amount, and any related remarks.

### 3. Automated Order Completion
In the `AddInvoiceDialog`, when you save an invoice, the system now calculates if the quantities being invoiced fulfill the entire remaining quantity for the order.
- If **all** items have a remaining quantity of `0` after the invoice is generated, the order's status is automatically updated to `"Completed"`.
- The orders list will refresh instantly to reflect this new status.

You can hot restart your app and verify these changes by opening a ledger and clicking the info icons, or by fully invoicing an order to see its status flip!
