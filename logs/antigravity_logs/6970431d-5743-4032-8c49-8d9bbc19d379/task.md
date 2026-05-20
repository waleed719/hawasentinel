# Task List

- `[x]` **1. Invoice datasource** — Change initial status to `undispatched`, fix `updateInvoiceStatus` (remove UnsupportedError), stop deriving status from payment summaries
- `[x]` **2. Invoice providers** — Add `updateInvoiceStatus` provider
- `[x]` **3. AddReceiptDialog** — Rewrite: remove invoice selection, client-only receipt form
- `[x]` **4. ReceiptsDashboard** — Remove `getAllInvoicesProvider` invalidation
- `[x]` **5. InvoicesDashboard** — Full rewrite: stateful, sort/filter, Update Status button, View Invoice dialog
- `[x]` **6. Build check** — `flutter analyze` passes (only pre-existing info warnings)
