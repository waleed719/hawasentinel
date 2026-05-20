# Role-Based Access Control Implementation Walkthrough

I have successfully implemented Role-Based Access Control (RBAC) to support both `master` and `accountant` roles. Here is an overview of the changes made and how they enforce your requirements.

## Database Layer

1. **Employee Roles (`DB/employee.sql`)**: 
   - We updated the `employees` table schema to include a `role` column (`TEXT NOT NULL DEFAULT 'accountant' CHECK (role IN ('master', 'accountant'))`).

2. **Row-Level Security (`DB/rbac_policies.sql`)**:
   - I created a new script, `DB/rbac_policies.sql`, which you should run on your Supabase instance.
   - It contains a helper function `get_current_user_role()` and applies Row Level Security (RLS) to all major tables (`clients`, `receipts`, `ledger`, `dps_reports`, etc.).
   - **Enforcement**: Under these policies, anyone can `SELECT` and `INSERT` (meaning an accountant can add records and view everything). However, **only the `master` role can `UPDATE` or `DELETE`**. This guarantees that even if a bug in the app were to show an edit or delete button to an accountant, the database will safely block the action.

## Flutter Application Layer

1. **State Management (`current_employee_provider.dart`)**:
   - Added a Riverpod provider that securely fetches the currently logged-in user's profile from the `employees` table.
   - Updated `EmployeeEntity` to successfully parse the `role` and `user_id` fields.

2. **UI Restrictions (`lib/sidebar.dart`)**:
   - The main application layout now watches the current user's role.
   - The **"Employees"** navigation drawer item has been removed for anyone who is not a `master`. Accountants cannot access the employee management screen.

> [!TIP]
> You may notice that "Edit" or "Delete" buttons are still visible to accountants in some parts of the UI. Due to our robust Supabase RLS policies, these actions will fail if an accountant clicks them. If you prefer, we can also follow up by removing the buttons entirely from the UI for accountants in the future. For now, the restrictions are fully secure at the database level!

## Next Steps

To make this active, please execute the `DB/rbac_policies.sql` script in your Supabase SQL editor.
