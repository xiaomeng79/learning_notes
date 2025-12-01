# AI Agent

## 资料
- [google-adk](https://google.github.io/adk-docs/agents/)
- [agentic-design-patterns](https://github.com/xindoo/agentic-design-patterns.git) [Agent设计模式](./Agent设计模式.md)
## 什么是AI Agent
一般叫智能体，能力为：通过感知环境、再有知识库增强、通过大模型推理决策、然后执行。

## 原理
- 通过将大模型作为主要组件来扩展感知和行动空间，并通过策略如多模态感知和工具使用来制订具体的行动计划。
- 通过反馈学习和执行新的动作，借助庞大的参数以及大规模的语料库进行预训练，从而得到世界知识(World Knowledge)。
- 通过思维链(Chain of Thought,CoT)、ReAct(Reasoning and Acting)和问题分解(Problem Decomposition)等逻辑框架，使得Agent展现出非常强大的推理和规划能力。
- 通过与环境的互动，从反馈中学习并执行新的动作，获得交互能力。
- 通过结合记忆的知识和上下文来执行任务。此外，还可以通过检索增强生成(RAG)和外部记忆系统(Memory Bank)整合来形成外部记忆。

## AI Agent的技术框架
- 规划：Agent需要具备规划（同时也包含决策）能力，以有效地执行更复杂的任务，这涉及到子目标的分解、连续的思考、自我反思和批评，以及对表征行动的反思。
- 记忆: 则包括短期记忆和长期记忆，短期记忆与上下文学习有关，而长期记忆则涉及信息的长时间保留和检索。
- 工具: 包括Agent可能调用的各种工具，如日历、计算器、代码解释器和搜索功能等，这些工具扩展了Agent的行动能力，使其能够执行更复杂的任务。
- 行动： Agent基于规划和记忆来执行具体的行动。这可能包括与外部世界互动，或者通过调用工具来完成一个动作(任务)。
