# Track and Display API Usage

The user wants to monitor model usage (specifically remaining usage) during the agent's run to understand why it might fail after several calls.

## Proposed Changes

### [agent.py](file:///home/waleedqamar/Documents/hackaton/HawaSentinelDemo/agent.py)

- Add `total_tokens` tracking to `HawaSentinelAgent`.
- Update `_call_llm` to:
    - Capture `usage` (prompt/completion tokens) from the JSON response.
    - Capture rate limit headers (e.g., `x-ratelimit-remaining-requests`) if they exist.
    - Provide detailed error messages for 429 (Rate Limit) and 401 (Invalid Key) errors.
- Include usage data in the events yielded by `run()`.

### [app.py](file:///home/waleedqamar/Documents/hackaton/HawaSentinelDemo/app.py)

- Add a new "📊 API Usage" section to the sidebar.
- Display cumulative tokens used.
- Display "Remaining Requests/Tokens" if the API provides those headers.
- Update the live event stream to show usage per step.

## Verification Plan

### Automated Tests
- Mock a response with `usage` and `X-RateLimit` headers to verify the agent captures and yields them correctly.

### Manual Verification
- Run the agent and observe the sidebar/logs for usage updates.
