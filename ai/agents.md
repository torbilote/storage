# AI Agents Notes

## Introduction

### Simple Definition:
An **AI Agent** is an AI model capable of **reasoning, planning, and interacting** with its environment.

### Technical Definition:
An **AI Agent** is a system that leverages an AI model to interact with its environment to achieve a **user-defined objective**. It combines **reasoning, planning, and execution of actions** (often via external tools) to fulfill tasks.

### Components of an AI Agent:
1. **Brain (AI Model)** – Handles reasoning and planning, deciding which actions to take based on the situation.
2. **Body (Tools and Capabilities)** – Represents everything the agent is equipped with to interact with the environment.

Most AI agents utilize **Large Language Models (LLMs)** as their primary reasoning component.

---

## System Messages
System Messages (also called **system prompts**) define how the model should behave. They serve as persistent instructions guiding every interaction.

### Example:
```python
system_message = {
  "role": "system",
  "content": "You are a professional customer service agent. Always be polite."
}
```
System messages provide:
- Information about available tools.
- Formatting instructions for actions.
- Thought process segmentation guidelines.

---

## Chat Templates
Chat templates structure communication between the **user and the agent**, ensuring the model receives correctly formatted prompts while preserving conversation history.

### Example Conversation:
```python
conversation = [
    {"role": "user", "content": "I need help with my order"},
    {"role": "assistant", "content": "I'd be happy to help. Could you provide your order number?"},
    {"role": "user", "content": "It's ORDER-123"},
]
```
The chat template converts messages into a structured prompt for the model.

---

## Basic vs. Instruct Models
- **Basic Model**: Trained on raw text data to predict the next token.
- **Instruct Model**: Fine-tuned to follow instructions and engage in structured conversations.

---

## Tools
A **tool** is a function given to an LLM to perform a specific action. Tools extend the model's capabilities beyond its training data.

### A Good Tool Should:
- Complement the **LLM's strengths** (e.g., use a calculator tool instead of relying on LLM’s native arithmetic abilities).
- Provide **real-time data** (e.g., weather updates, stock prices).

### Tool Components:
- A **textual description** of its purpose.
- A **callable function** to execute actions.
- Arguments with **type definitions**.
- (Optional) Outputs with **type definitions**.

---

## How Tools Work
LLMs can **only process text inputs and outputs**. They cannot execute tools directly but can **generate structured text (e.g., JSON, Python code) that invokes tools**.

### Example: Weather Lookup Tool
If we provide a **weather-checking tool**, and the user asks, *“What’s the weather in Paris?”*, the LLM will generate a tool invocation request instead of an answer:
```json
{"name": "check_weather", "arguments": "Paris"}
```
The **Agent** then:
1. Recognizes the tool call request.
2. Executes the tool.
3. Returns the tool's output to the LLM.
4. The LLM integrates the tool output into a response for the user.

### Example of Providing Tool Access:
```python
system_message = "[..] You have access to the following tools: <tools description>. "
```
Tools help **overcome model limitations, provide real-time data, and perform specialized actions**.

---

## Thought-Action-Observation Cycle
Agents operate in a **continuous loop** until the task is completed:
1. **Thought** – The LLM decides the next step.
2. **Action** – The agent calls tools with relevant arguments.
3. **Observation** – The model reflects on the tool's response and determines the next step.

### **ReAct (Reasoning + Acting) Approach**
A prompting technique that **encourages step-by-step problem solving** before generating a final solution.

---

## Types of Agent Actions

### 1. **Tool-Calling Agent**
- Generates structured **JSON** to invoke tools.
- Best for **simple tool execution** without variable handling.

### 2. **Code Agent**
- Generates **Python code** that is executed externally.
- Best for **complex logic, iterative reasoning, and multi-step execution**.

#### Example:
If an agent needs to **search for catering services**, a **Code Agent** would generate and run Python code:
```python
for query in [
    "Best catering services in Gotham City", 
    "Party theme ideas for superheroes"
]:
    print(web_search(f"Search for: {query}"))
```
A **Tool-Calling Agent** would instead generate JSON:
```json
[
    {"name": "web_search", "arguments": "Best catering services in Gotham City"},
    {"name": "web_search", "arguments": "Party theme ideas for superheroes"}
]
```
**Comparison:**
- **Code Agents**: More flexible and powerful.
- **Tool-Calling Agents**: Simpler, but limited.

---

## Retrieval-Augmented Generation (RAG)
### What is RAG?
RAG systems **combine retrieval-based search with generative models** for more informed responses.

### How It Works:
1. A **user query** is passed to a search engine.
2. The retrieved results are **provided to the LLM** along with the query.
3. The LLM **generates a response** based on the retrieved data.

### **Agentic RAG vs. Traditional RAG**
| Feature | Traditional RAG | Agentic RAG |
|---------|---------------|-------------|
| Query Process | Uses a **single** retrieval step | Uses **multiple** retrieval steps |
| Context Handling | Focuses on **direct similarity** | **Critiques & refines** search results |
| Decision Making | LLM **answers based on retrieval** | Agent **controls retrieval & generation** |

**Agentic RAG** enhances traditional RAG by allowing the agent to:
- Autonomously **formulate search queries**.
- **Critique retrieved results** for relevance.
- Perform **multi-step retrieval** to refine information.

---
