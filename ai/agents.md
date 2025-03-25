# AI Agents Notes

Introduction
Simple definiton:
AI Agent is an AI model capable of reasoning, planning, and interacting with its environment.

More technical definition:
AI Agent is a system that leverages an AI model to interact with its environment in order to achieve
a user-defined objective. It combines reasoning, planning, and the execution of actions (often via external tools) to fulfill tasks.

Think of agent as having two parts:
a) brain (ai model) - this is where all the thinking happens. It handles reasoning and planning. It decides which actions to take based on the situation.
b) body (tools and capabilities) - this represents everything the agent is equipped with.

Most common AI model found in AI Agents is Large Language Model (LLM).

System Messages (also called system prompts) define how the model should behave. They serve as persistent instructions guiding every subsequent interaction.
For example
```python
system_message = {
  "role": "system",
  "content": "You are a professional customer service agent. Always be polite."
}
```

When using Agents, the System Message gives information about the available tools, provides instructions to the model on how to format the actions to take,
and includes guidelines on how the thought process should be segmented.

Chat templates structure the communication between user and the agent, ensuring the model receives correctly formatted prompt. They also preserve conversation history.

Conversation example:
```python
conversation = [
    {"role": "user", "content": "I need help with my order"},
    {"role": "assistant", "content": "I'd be happy to help. Could you provide your order number?"},
    {"role": "user", "content": "It's ORDER-123"},
]
```
Chat template actually converts all the messages inside this Python list into a prompt, which is just a string input that contains all the messages.

We can name a model a basic model when is trained on raw text data to predict the next token.
An instruct model on the other hand is fine-tuned specifically to follow instructions and engage in conversations. They have formatted chat templates in consistent way the model can understand.

# Tools
A tool is a function given to LLM. This function should fulfill a clear objective.
You can create a tool for any use case that can be achieved by writing a code.
A good tool should be something that complements the power of LLM.
For instance, if you need to perform arithmetic, giving a calculator tool to your LLM will provide better results than relying on the native capabilites of the model.
Also, models predict the tokens based on their training data, which means their internal knowledge only includes events prior to their training. If your agent needs up-to-date data, you must provide it through some tool.

A tool should contain:
- a textual description of what the function does.
- a callable (something to perform an action).
- arguments with typings.
- Optionally outputs with typings.

# How the tools work
LLMs, as we saw, can only receive text inputs and generate text outputs. They have no way to call tools on their own. What we mean when we talk about providing tools to an Agent, is that we teach the LLM about the existence of tools, and ask the model to generate text that will invoke tools when it needs to. For example, if we provide a tool to check the weather at a location from the Internet, and then ask the LLM about the weather in Paris, the LLM will recognize that question as a relevant opportunity to use the “weather” tool we taught it about. The LLM will generate text, in the form of code, to invoke that tool. It is the responsibility of the Agent to parse the LLM’s output, recognize that a tool call is required, and invoke the tool on the LLM’s behalf. The output from the tool will then be sent back to the LLM, which will compose its final response for the user.

The output from a tool call is another type of message in the conversation. Tool calling steps are typically not shown to the user: the Agent retrieves the conversation, calls the tool(s), gets the outputs, adds them as a new conversation message, and sends the updated conversation to the LLM again. From the user’s point of view, it’s like the LLM had used the tool, but in fact it was our application code (the Agent) who did it.

To grant the model an access to the tool we simply provide a textual description of it within the system prompt.
Though it has to be very precise and accurate about what the tool does and what input it expects.

```python
system_message = "[..] You have access to the following tools: <tools description>. "
```

Tools enable agents to overcome limitations of statis model training, handle real-time tasks and perform specialized actions.

## Thought-Action-Observation Cycle
Agents work in a continuious cycle of the following loop until the objective is fulfilled:
thinking (Thought) -> acting and observing (Act and Observe)

Thought - The LLM part of the agent decides what the next step should be.
Action - The agent takes an action by calling the tools with the associated arguments.
Observation - The model reflects on the response from the tool.

A key method ReAct approach is a prompting technique that appends "Let's think step by step" before letting LLM decode the next tokens.
Since it is encouraged to decompose the problem into sub-tasks it process towards token that generate the plan rather the final solution which gives better results.

# Types of Agent Action 

Tool Calling Agent - The action to take is specified in JSON format.
Code Agent - The Agent writes a code block that is interpreted externally.

Inference is the process of using a trained model running on a dedicated or external service. 

For example if agent wants to search internet for catering services and party ideas, a Code Agent would generate and run Python code like this:
```python
for query in [
    "Best catering services in Gotham City", 
    "Party theme ideas for superheroes"
]:
    print(web_search(f"Search for: {query}"))
```
A Tool Calling Agent would instead create JSON blob which is used to exectue the tool calls:
```json
[
    {"name": "web_search", "arguments": "Best catering services in Gotham City"},
    {"name": "web_search", "arguments": "Party theme ideas for superheroes"}
]
```
While Code Agents perform better overall, Tool Calling Agents can be effective for simple systems that dont require variable handling or complex tool calls.

# RAG
Retrieval Augmented Generation (RAG) systems combine the capabilities of data retrieval and generation models to provide context-aware responses.
For example, a user’s query is passed to a search engine, and the retrieved results are given to the model along with the query. The model then generates a response based on the query and retrieved information.

Agentic RAG (Retrieval-Augmented Generation) extends traditional RAG systems by combining autonomous agents with dynamic knowledge retrieval.
While traditional RAG systems use an LLM to answer queries based on retrieved data, agentic RAG enables intelligent control of both retrieval and generation processes, improving efficiency and accuracy.

Traditional RAG systems face key limitations, such as relying on a single retrieval step and focusing on direct semantic similarity with the user’s query, which may overlook relevant information.

Agentic RAG addresses these issues by allowing the agent to autonomously formulate search queries, critique retrieved results, and conduct multiple retrieval steps for a more tailored and comprehensive output.