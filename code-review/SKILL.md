---
name: code-review
description: "Mandatory code review after every coding task. Use when Codex has completed any code changes (new files, edits, refactors) across any language or framework. Covers syntax validation, style compliance, logic correctness, security review, and dependency checks. Automatically triggered after coding work is done."
---

# Code Review

After completing any coding task, perform a mandatory review of all changed code.

## Review Checklist

Run through each item below. Do not skip.

### 1. Syntax & Compilation

- For Java projects: run `mvn compile` in the affected module to verify compilation
- For frontend projects (Vue/React): run `npm run lint` or equivalent linter
- For Python: run `python -m py_compile <file>` or `python -m flake8 <file>` if available
- For any language without a configured linter: manually inspect for obvious syntax errors

### 2. Style & Conventions

- Check new code matches the project's existing style (Lombok vs getter/setter, Gson vs Fastjson, etc.)
- Verify naming conventions: classes PascalCase, methods/variables camelCase, constants UPPER_SNAKE_CASE
- Check imports are organized and unused imports are removed
- Ensure no trailing whitespace, consistent indentation

### 3. Logic & Correctness

- Verify business logic matches the requirement
- Check edge cases: null/empty inputs, boundary values, error states
- Ensure exception handling is present and appropriate (not swallowing exceptions silently)
- For Java: verify `@Transactional` annotations are present on write operations

### 4. Security

- Check for SQL injection risks (use parameterized queries, not string concatenation)
- Check for XSS risks in frontend code
- Verify no hardcoded credentials, tokens, or secrets
- Check that user input is validated/sanitized

### 5. Dependencies

- Verify new imports/dependencies are actually used
- Check for circular dependencies between modules
- Ensure no accidental changes to forbidden files (see project AGENTS.md / CLAUDE.md)

## Review Output

After review, report findings to the user:
- Issues found, ordered by severity (P0 blocking, P1 should-fix, P2 nice-to-have)
- What was fixed during review
- Any remaining risks or recommendations

If no issues found, state that clearly.
