# HawaSentinel - Hackathon Video Submission Scripts

Based on the official submission checklist, you need to submit **two separate videos**. 

---

## Video 1: End-to-End Agentic Workflow (3-5 Minutes)
**Goal:** Prove the system observes, reasons, decides, acts, evaluates, and adapts. Show it is NOT just a hard-coded dashboard.

### 0:00 - 0:30 | Introduction & Problem
* **Visual:** Open the HawaSentinel Flutter Mobile App showing the current live UI.
* **Voiceover:** "Welcome to HawaSentinel. In Punjab, crop burning and industrial emissions create hazardous smog. Traditional dashboards only show the AQI. HawaSentinel uses a local, multi-agent AI system to autonomously orchestrate city-wide crisis responses."

### 0:30 - 1:15 | Observation & Reasoning (The Trigger)
* **Visual:** Show the app displaying a "HAZARDOUS" AQI level (e.g., 540). Tap the "Run Agent Analysis" button. 
* **Voiceover:** "When the AQI crosses a critical threshold, our system doesn't just alert users. It triggers our Orchestrator Agent. The Orchestrator sequentially dispatches 6 domain-specific agents—School, Hospital, Rider, Farmer, Traffic, and Factory—giving them the current environmental data."
* **Visual (Side-by-side or cut):** Show the Node.js backend terminal logs where agents are reasoning. e.g., `[schoolAgent] Calling tool: get_affected_schools`.
* **Voiceover:** "As you can see in the backend logs, these are not hard-coded rules. The agents are using the ReAct framework to observe the data, reason about the severity, and select appropriate tools."

### 1:15 - 2:30 | Decisions & Actions (The Impact)
* **Visual:** Go back to the Flutter app and highlight the new "Active Agent Actions" cards that just populated.
* **Voiceover:** "The agents have made their decisions. For example, the Hospital Agent evaluated the smog severity and predicted a surge in respiratory patients. It autonomously decided to reallocate resources. The Factory Agent identified severe emission violations and issued shutdown orders."
* **Visual:** Focus on the "IMPACT SIMULATION" section of the cards (The Before -> After strikethrough).
* **Voiceover:** "Notice the concrete impact. Before: Hospitals Unprepared. After: 25 Beds Reallocated. Before: Unmonitored Crop Burning. After: 1500 Farmers Warned and Patrols Dispatched."

### 2:30 - 3:15 | Robustness Evidence (Crucial Checklist Item)
* **Visual:** Show the `baseAgent.js` code briefly, specifically the JSON hallucination repair `try/catch` block.
* **Voiceover:** "Because we are running smaller, quantized 4B and 7B models locally via Ollama to ensure data privacy and zero API costs, the LLMs occasionally hallucinate markdown formatting. To ensure extreme robustness, we built a self-healing parser. If an agent outputs malformed JSON, our system strips the markdown, and if it completely fails, it triggers a safe 'monitor' fallback so the orchestrator never crashes."

### 3:15 - 3:45 | Baseline Comparison & Scalability
* **Visual:** Show a quick static slide or point to the README section.
* **Voiceover:** "Compared to a simple heuristic system that just sends an SMS when AQI > 300, HawaSentinel dynamically predicts hospital surges and reroutes delivery riders based on wind direction. By running local Ollama models on a centralized EC2 instance, our cost per operation is effectively zero, making this infinitely scalable across all districts of Punjab."

### 3:45 - 4:00 | Conclusion
* **Voiceover:** "HawaSentinel turns passive data into proactive, autonomous crisis management. Thank you."

---
---

## Video 2: How We Used Antigravity (2-3 Minutes)
**Goal:** Show that Antigravity was the "Core Architect" of the system, not just an autocomplete tool.

### 0:00 - 0:30 | Introduction
* **Visual:** Open the Antigravity IDE showing the chat history and the workspace.
* **Voiceover:** "For our project, Google's Antigravity was much more than a code assistant. It acted as our primary Systems Architect. From day one, it conceptualized our entire multi-agent ecosystem."

### 0:30 - 1:15 | Architecting the ReAct Loop
* **Visual:** Scroll through the Antigravity chat logs where you asked it to build the backend. Show the `baseAgent.js` file.
* **Voiceover:** "We relied on Antigravity to engineer the core reasoning logic. It designed our custom ReAct loop from scratch in Node.js. It figured out exactly how the prompt engineering needed to be structured to force smaller local models to reliably choose tools and output strict JSON."

### 1:15 - 2:00 | UI/UX & The Stitch Design System
* **Visual:** Show Antigravity generating the Flutter UI code, and then show the resulting app.
* **Voiceover:** "On the frontend, Antigravity autonomously scaffolded our entire Flutter dashboard. It integrated the Stitch Atmospheric Sentinel design system, implementing complex animations and the dynamic 'Before/After' impact visuals with very little manual intervention."

### 2:00 - 2:45 | Autonomous Refactoring & Migration
* **Visual:** Show the `orchestratorAgent.js` file with the 6 agents. 
* **Voiceover:** "Antigravity's strongest contribution was in refactoring. Halfway through the hackathon, we decided to migrate away from paid APIs to a completely local, privacy-first Ollama infrastructure. Antigravity planned and executed this complex migration flawlessly. It also autonomously scaled our system from 3 agents to 6 agents without breaking the synchronous JSON parsing."

### 2:45 - 3:00 | Conclusion
* **Voiceover:** "Antigravity didn't just write our code; it guided our architectural decisions, ensuring our agentic workflow was robust, scalable, and technically sound."
