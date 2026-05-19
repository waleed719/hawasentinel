import OpenAI from 'openai';

const openai = new OpenAI({
  baseURL: 'https://58e3-96-231-126-101.ngrok-free.app/v1',
  apiKey: 'ollama' // Required but ignored by ollama
});

export class BaseAgent {
  constructor({ name, systemPrompt, tools, toolExecutors }) {
    this.name = name;
    this.systemPrompt = systemPrompt;
    this.tools = tools;
    this.toolExecutors = toolExecutors;
    this.model = 'llama3.2:3b'; // Or llama3.2:3b / mistral:latest  /  qwen2.5:7b
  }

  async run(inputData) {
    console.log(`[${this.name}] Starting execution...`);
    const startTime = Date.now();

    const messages = [
      { role: "system", content: this.systemPrompt },
      { role: "user", content: `Here is the current situation data:\n${JSON.stringify(inputData)}\nPlease analyze this data and make your decision. Reply ONLY with valid JSON.` }
    ];

    try {
      let iterations = 0;
      const maxIterations = 5;

      while (iterations < maxIterations) {
        iterations++;
        const response = await openai.chat.completions.create({
          model: this.model,
          messages: messages,
          tools: this.tools && this.tools.length > 0 ? this.tools : undefined,
          tool_choice: this.tools && this.tools.length > 0 ? 'auto' : undefined,
          response_format: { type: 'json_object' }
        });

        const message = response.choices[0].message;
        messages.push(message);

        if (message.tool_calls && message.tool_calls.length > 0) {
          for (const toolCall of message.tool_calls) {
            const toolName = toolCall.function.name;
            const args = JSON.parse(toolCall.function.arguments);
            console.log(`[${this.name}] Calling tool: ${toolName}`, args);

            let toolResult;
            if (this.toolExecutors[toolName]) {
              try {
                toolResult = await this.toolExecutors[toolName](args);
              } catch (e) {
                toolResult = { error: e.message };
              }
            } else {
              toolResult = { error: `Tool ${toolName} not found` };
            }

            messages.push({
              role: 'tool',
              tool_call_id: toolCall.id,
              content: JSON.stringify(toolResult)
            });
          }

          // Delay to avoid overwhelming local model
          await new Promise(r => setTimeout(r, 1000));
        } else {
          // No more tool calls, parsing final JSON
          const timeTaken = Date.now() - startTime;
          console.log(`[${this.name}] Execution finished in ${timeTaken}ms`);

          try {
            return JSON.parse(message.content);
          } catch (e) {
            // In case it returns markdown JSON, try to strip it
            const match = message.content.match(/```json\n([\s\S]*)\n```/) || message.content.match(/```([\s\S]*)```/);
            if (match && match[1]) {
              return JSON.parse(match[1]);
            }
            throw e; // Reraise if still can't parse
          }
        }
      }
      throw new Error("Max tool call iterations reached without a final answer.");
    } catch (error) {
      console.error(`[${this.name}] Execution failed:`, error.message);
      return {
        agent: this.name,
        error: error.message,
        decision: "fallback"
      };
    }
  }
}
