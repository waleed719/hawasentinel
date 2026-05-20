# Walkthrough: API Usage Tracking & Improved Error Handling

I have implemented a feature to track and display Gemini API usage, including tokens and remaining quota (if provided by the API). I also improved the error handling to specifically identify rate limit (429) errors.

## Changes Made

### 🤖 Agent Tracking (`agent.py`)
- Added `total_tokens` and `usage_history` to `HawaSentinelAgent`.
- Updated `_call_llm` to capture `usage` data from the JSON response and lowercase all header keys for easier access.
- Implemented specific checks for **429 (Rate Limit)** and **401 (Unauthorized)** errors to provide clearer feedback to the user.
- Events now include `usage`, `total_tokens`, and `remaining_requests` / `remaining_tokens`.

### 🖥️ UI Enhancements (`app.py`)
- Added a **📊 API Usage** section to the sidebar that displays:
    - **Total Tokens Used** (cumulative for the session).
    - **Remaining Requests** (captured from API headers).
    - **Remaining Tokens** (captured from API headers).
- Updated the **Reasoning Stream** to show tokens used for each specific step and the running total.

## Verification
- The agent now captures and reports tokens used per step.
- If a rate limit is hit, the error message will explicitly state "Rate limit reached (429)" instead of a generic failure message.
