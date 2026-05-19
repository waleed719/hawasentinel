# HawaSentinel Backend Implementation Plan

We will build the complete Node.js + Express backend for HawaSentinel. 

## User Review Required

> [!WARNING]
> **LLM Provider Clarification**
> The initial prompt mentioned using the Groq API (`llama-3.1-8b-instant`), but the final instruction specified using a **Local OLLAMA `qwen3:4B`** model. 
> I will proceed with building the BaseAgent using the OpenAI SDK but configured to point to your **local Ollama instance** at `http://127.0.0.1:11434/v1` instead of Groq. Let me know if you would prefer to stick to Groq instead.

## Proposed Changes

We will create a new directory `hawasentinel-backend` and scaffold the following files:

### Project Configuration
- **`package.json`**: Will include dependencies (`express`, `openai`, `dotenv`, `axios`, `cors`), set `"type": "module"`, and configure the `start` and `dev` scripts.
- **`.env` and `.env.example`**: Will include the `PORT`, `IQAIR_API_KEY`, and `FIRMS_API_KEY` mapped from your provided `apis` file. 

### Core Agent Architecture
- **`agents/baseAgent.js`**: A reusable class extending an agent loop. It will initialize the `openai` client pointing to `http://localhost:11434/v1`, format messages, execute any tool calls requested by the model, loop until completion, and return parsed structured JSON.

### Specialized Agents
- **`agents/schoolAgent.js`**: Uses `get_affected_schools` and `draft_closure_notice` tools to decide on school closures.
- **`agents/hospitalAgent.js`**: Uses `predict_surge` and `reallocate_beds` tools to handle ER surge and bed reallocation.
- **`agents/riderAgent.js`**: Uses `get_pm25_hotspots` and `suggest_safe_routes` to manage gig worker routing.

### Orchestrator
- **`agents/orchestratorAgent.js`**: Runs the 3 agents in parallel using `Promise.all()`, calculates the overall crisis level, and shapes the final output payload.

### Data Fetching Layer (Tools)
- **`tools/iqair.js`**: Fetches real AQI data, falling back to a mock if the request fails.
- **`tools/nasaFirms.js`**: Fetches and parses fire/stubble-burning CSV data, falling back to a mock on failure.
- **`tools/openMeteo.js`**: Fetches wind speed and direction, falling back to a mock on failure.
- **`data/mockScenario.js`**: Hardcodes the Nov 2024 smog episode replay array.

### Express Server
- **`server.js`**: Implements three endpoints:
  - `POST /api/simulate`: Accepts `{ scenario }`, fetches appropriate data (live, mock, or replay), and runs the orchestrator (unless replay).
  - `GET /api/aqi`: Returns raw AQI data from the IQAir tool.
  - `GET /api/health`: Basic health check.

## Verification Plan
1. Create the full project structure.
2. Initialize npm and install dependencies.
3. Test the local API endpoints using basic fetch/curl commands to ensure that they respond correctly and the LLM agent tool-call loops handle tool calling gracefully.
