# Development Skills

This repository contains local agent skills used during software development. Each directory is an independent skill with a `SKILL.md` entry point that defines its purpose, trigger conditions, and workflow.

## Skill Catalog

| Skill | Purpose | Use it when |
| --- | --- | --- |
| [alibaba-java-guidelines-en](alibaba-java-guidelines-en/SKILL.md) | Applies P3C-aligned Java and Spring Boot coding rules. | Generating, editing, reviewing, or validating Java backend code and tests. |
| [brainstorming](brainstorming/SKILL.md) | Clarifies intent, goals, constraints, and design choices before work begins. | Starting creative work such as a new feature, component, behavior change, or project plan. |
| [code-review](code-review/SKILL.md) | Reviews changed code for syntax, conventions, correctness, security, and dependencies. | Completing any coding task before delivery. |
| [documentation-and-adrs](documentation-and-adrs/SKILL.md) | Records design reasoning and architecture decisions. | Documenting a design choice, shipping a feature with documentation impact, or writing an ADR. |
| [find-skills](find-skills/SKILL.md) | Discovers and installs additional agent skills. | Looking for an existing skill or deciding whether one should be installed. |
| [lean-ctx](lean-ctx/SKILL.md) | Selects focused code context and controls token-heavy reads, searches, and command output. | Reading, searching, or understanding a codebase with LeanCTX tools available. |
| [requesting-code-review](requesting-code-review/SKILL.md) | Requests an independent review with precise task context. | Completing major work, finishing a task in a multi-agent workflow, or preparing to merge. |
| [speckit-plan-hybrid](speckit-plan-hybrid/SKILL.md) | Builds or validates foundation-first delivery plans with hard gates and parallel feature tracks. | Creating a WBS, revising a delivery plan, or checking gate readiness from actual evidence. |
| [systematic-debugging](systematic-debugging/SKILL.md) | Finds the root cause before allowing any fix. | Investigating a bug, test failure, build failure, performance issue, or unexpected behavior. |
| [test-driven-development](test-driven-development/SKILL.md) | Drives implementation through a failing test and keeps the change focused. | Implementing any feature or bug fix. |
| [writing-plans](writing-plans/SKILL.md) | Converts requirements into an executable implementation plan. | Preparing to implement a multi-step task from a specification. |

## Recommended Development Flow

1. Use **brainstorming** to clarify the outcome and constraints before creative work.
2. Use **lean-ctx** to inspect relevant code and keep context focused.
3. For delivery planning, use **writing-plans** or **speckit-plan-hybrid** according to the task size and need for gate validation.
4. For defects, use **systematic-debugging** before proposing or applying a fix.
5. For implementation, use **test-driven-development**, plus **alibaba-java-guidelines-en** for Java Spring Boot backend work.
6. Record durable design decisions with **documentation-and-adrs**.
7. Review completed changes with **code-review**, and use **requesting-code-review** for an independent review before major merges.
8. Use **find-skills** when an existing skill does not cover the task.

Skills are intentionally scoped: invoke the smallest set needed for the current task rather than enabling every workflow by default.
