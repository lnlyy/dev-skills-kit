---
name: speckit-plan-hybrid
description: Generate foundation-first hybrid delivery WBS plans with hard gates and parallel feature tracks, or validate an existing plan's entry criteria, acceptance gates, and stop conditions against current deliverables. Use for project plan generation, WBS revision, gate-state validation, or readiness assessment.
metadata:
  short-description: Build or validate hybrid delivery plans
---

# Speckit Plan Hybrid

## Purpose

Create an engineering-ready hybrid delivery plan for software projects:

1. Build shared foundations serially with hard acceptance gates.
2. After all foundation gates pass, develop business features in parallel vertical slices.
3. Complete cross-feature hardening and final acceptance after feature integration.

The result must be executable by an engineering team, not merely descriptive.

## Operating Modes

This skill supports two operating modes.

### Mode A: Plan Generation

Input project documents, requirements, constraints, existing milestones, and existing assets. Produce a hybrid delivery WBS following the stage model, gate rules, output format, and quality checklist in this skill.

Output:

- Foundation-first serial WBS.
- Parallel feature tracks.
- Dependencies and deliverables.
- Entry criteria, acceptance gates, and stop conditions.
- Risk register.
- Milestone acceptance alignment.

### Mode B: Gate State Validation

Input an existing delivery plan or WBS, current deliverables, implementation state, test or review evidence, deployment evidence, known blockers, and deferred scope.

Evaluate each entry criterion, acceptance gate, and stop condition against available evidence. Do not infer completion from task claims alone; require observable evidence where the plan defines it.

For each evaluated item, output:

- Item ID and name.
- Criterion type: entry criterion, acceptance gate, or stop condition.
- Judgement: `true`, `false`, or `insufficient-evidence`.
- Evidence used.
- Missing or failing evidence.
- Affected downstream tasks.
- Blocker severity.
- Recommended next action: `rework`, `scope-trim`, or `pause-assessment`.
- Concrete next step.

Mode selection:

- Create, revise, or convert a plan: Mode A.
- Check progress, validate gates, audit readiness, or decide whether to proceed: Mode B.
- If the mode is ambiguous and the modes would produce materially different outputs, ask which mode is required.

## Required Inputs

Collect available inputs before working:

- Requirements or product scope.
- Existing milestone or roadmap documents.
- Architecture and technology constraints.
- Existing code, infrastructure, data models, and reusable assets.
- Team or delivery constraints, if known.
- Quality, security, compliance, deployment, and operations requirements.
- Existing authoritative planning or progress documents, if present.

If a repository already has authoritative planning documents, respect them. Do not silently replace them. Identify conflicts explicitly and mark decisions requiring human confirmation.

If critical information is missing, do not invent facts. Mark the item as a blocker, assumption, or open question.

## Core Rules

1. The delivery model has two major phases:
   - Foundation Construction: serial, gate-controlled, shared capabilities.
   - Business Feature Construction: parallel, feature-oriented, vertical delivery.
2. Shared foundation work must not be distributed into individual business features.
3. A later foundation layer cannot start until the previous layer passes its acceptance gate.
4. Business feature development cannot start until the complete foundation phase passes its final gate.
5. Existing milestones are acceptance checkpoints only, not the primary grouping mechanism for internal development tasks.
6. Every stage and task must define entry criteria, deliverables, acceptance gates, stop conditions, dependencies, and whether it can run in parallel.
7. Every gate must be objectively verifiable. Statements such as "basically complete" or "architecture looks good" are invalid without evidence.
8. Foundation work includes a minimal walking skeleton proving deployment, data, security, logging, tracing, and one representative end-to-end path. This is technical validation, not a business feature commitment.
9. Each feature must remain a vertical slice. Do not organize work as all backend first, then all frontend.
10. Cross-feature shared assets require explicit change control, including database schema, public API contracts, event contracts, permission models, routing, navigation, and shared UI patterns.

## Stage 1: Foundation Construction

Stage 1 is serial. Each sub-stage must pass its gate before the next begins.

### 1.1 Discovery and Survey

Goal: understand current state, scope, constraints, risks, existing assets, and unresolved requirements.

Scope:

- Business objectives and non-goals.
- Existing requirements and milestones.
- Current architecture and codebase.
- Existing infrastructure and deployment state.
- Reusable components and technical debt.
- Security, compliance, data, and operational constraints.
- Requirement ambiguity and delivery risk.

Deliverables:

- Project survey report.
- Existing asset inventory.
- Reuse, migrate, replace, or retire recommendations.
- Requirement ambiguity list.
- Initial architecture and delivery risks.
- Scope boundary and non-goals.

Acceptance gate:

- Scope, goals, and non-goals are explicit.
- Existing assets are classified.
- High-risk assumptions are identified.
- Ambiguous requirements are marked for clarification.
- Conflicts with authoritative plans are listed.
- Foundation scope is defined clearly enough to estimate.

Stop conditions:

- Business objectives or system boundary are unknown.
- Authoritative documents conflict in a way that changes plan structure.
- A critical legal, security, compliance, or operational constraint is missing.

### 1.2 Shared Foundation

Goal: build the global technical base shared by all business modules.

Include only capabilities affecting multiple features or the whole system:

- Architecture decisions and technology baseline.
- Global data model and migration mechanism.
- Runtime and deployment foundation.
- CI/CD pipeline.
- Coding, testing, and review standards.
- Authentication, authorization, and audit baseline.
- Secrets and credential management.
- Logging, metrics, and tracing foundation.
- Error handling and API response conventions.
- Shared libraries and internal SDKs.
- Local development environment.

Do not include feature-specific business logic.

Acceptance gate:

- Architecture review is recorded, with reviewers and decisions.
- Global data model review is recorded.
- CI/CD runs successfully on a representative change.
- Foundation deploys to the target or an equivalent environment.
- Security and audit baselines are wired into the walking-skeleton path.
- Logging and tracing identify requests across at least two components.
- Engineering standards are actionable and linked to executable checks where possible.

Stop conditions:

- A foundational technology choice has unresolved high-impact risk.
- The global model cannot support confirmed core business flows.
- Deployment, security, or pipeline baseline cannot be verified.
- A required foundation decision remains contested.

### 1.3 Core Domain Skeleton

Goal: establish core domain structure and the main cross-module flow without implementing full feature details.

Scope:

- Domain boundaries.
- Core domain objects.
- Core service contracts.
- Cross-module business flow.
- Global event or integration model.
- Public API boundary and compatibility strategy.
- Cross-cutting state and transaction boundaries.

Acceptance gate:

- Domain boundaries and ownership are agreed.
- Core contracts are reviewed by affected parties.
- The main business flow is represented end to end.
- Shared state, transaction, and integration boundaries are explicit.
- Deferred feature scope is listed.

Stop conditions:

- Core domain boundaries remain unclear.
- Cross-module flow cannot be expressed without conflicting ownership.
- Contracts required by multiple features remain undefined.

### 1.4 Foundation Walking Skeleton

Goal: prove the foundation works as one connected system through one minimal representative technical path.

The path should cover deployment, authentication or access control where applicable, one representative request or transaction, persistence, audit logging, application logging, tracing or correlation ID propagation, automated tests, and CI/CD integration.

Final foundation unlock gate:

- The walking skeleton deploys reproducibly.
- The representative path succeeds.
- Persistence, authentication, audit, logging, and tracing evidence exists.
- Automated tests and pipeline pass.
- No known blocking foundation gap remains.

Business feature development starts only after this gate passes.

## Stage 2: Business Feature Construction

Decompose by business capability or user-facing outcome, not by technical layer.

Each feature is a vertical slice containing:

1. Contract and failure tests.
2. Feature-level design.
3. Data or schema changes.
4. Backend implementation where applicable.
5. Frontend implementation where applicable.
6. Integration with foundation capabilities.
7. Unit and integration tests.
8. Feature self-test report.
9. Completion evidence.

Dependency types:

- Hard dependency: the feature cannot start until the dependency completes.
- Partial dependency: only part of the feature is blocked.
- Shared-asset dependency: work proceeds only with coordinated schema, API, event, permission, routing, or design changes.
- No dependency: work can run independently.

Parallel execution rules:

- Features without blocking dependencies may run in parallel.
- Split partially blocked features so unblocked work can continue.
- Assign an owner and review sequence to shared-asset changes.
- Integrate continuously or on a defined cadence; do not defer all integration to the end.

A feature is complete only when:

- Its contract is implemented and tested.
- Main and boundary paths are covered.
- It uses approved foundation capabilities.
- It does not bypass security, audit, logging, tracing, or deployment standards.
- Tests and static checks pass.
- Documentation and self-test report are complete.
- Integration evidence is recorded.

## Stage 3: Cross-Feature Hardening

Some preparation may begin earlier if dependencies are satisfied, but final hardening runs after relevant feature modules complete.

Early-allowed work:

- Monitoring and alerting framework setup.
- Runbook templates.
- Environment governance.
- Performance and security test scaffolding.
- Shared operational scripts that do not depend on final feature behavior.

Post-feature work:

- End-to-end monitoring and alert tuning.
- Cross-feature tracing verification.
- Performance optimization and capacity planning.
- Security hardening.
- Compatibility verification.
- Error handling and recovery review.
- UI consistency and accessibility review.
- Operational readiness review.

Acceptance gate:

- Cross-feature paths are observable.
- Alerts and runbooks are actionable.
- Performance and security criteria are met.
- Failure, recovery, and boundary scenarios are tested.
- User-facing inconsistencies are resolved or explicitly accepted.

## Stage 4: Final Acceptance and Delivery

Scope:

- Integration, system, regression, security, and performance testing.
- Operational readiness review.
- Release and rollback rehearsal.
- Business acceptance.
- Documentation and handover.

Deliverables:

- Integration test report.
- System and regression test report.
- Security test report.
- Performance test report.
- Acceptance test report.
- Release and rollback plans.
- Operations runbook.
- Final milestone acceptance record.

Final acceptance passes only when:

- All planned features meet their gates.
- Cross-feature hardening gates pass.
- Test evidence is complete.
- Release and rollback procedures are verified.
- Business acceptance is recorded.
- Residual risks, deferrals, and mitigations are explicitly approved.

## WBS Requirements

Every task must include:

- Task ID.
- Stage.
- Task name.
- Task type: serial, parallel, shared-asset control, or gate.
- Predecessor task IDs.
- Deliverables.
- Entry criteria.
- Acceptance gate.
- Stop condition.
- Risk or dependency note.
- Owner, if known.

Do not fabricate owners, dates, estimates, or decisions. Mark unknown values as `TBD` and identify who must supply them.

## Risk Model

Separate foundation risks from business feature risks.

Foundation risks include architecture scalability, data model fit, incomplete authorization, unstable deployment, conflicting contracts, and unsafe existing assets.

Business feature risks include ambiguous requirements, wrong workflow assumptions, underestimated dependencies, complex external integration, and unclear acceptance criteria.

For every material risk, record:

- Risk ID.
- Risk type.
- Affected tasks.
- Probability.
- Impact.
- Trigger or early warning signal.
- Mitigation.
- Stop condition.
- Owner, if known.

## Output Format

For Mode A, produce:

1. Executive survey: objective, current state, scope, non-goals, asset summary, assumptions, and blockers.
2. Plan shape: foundation serial, features parallel, cross-feature hardening, final acceptance.
3. Existing asset disposition: reuse, migrate, replace, retire, or needs spike.
4. Stage WBS with dependencies, deliverables, gates, stop conditions, and parallelism.
5. Dependency map showing serial gates, parallel tracks, partial dependencies, and shared-asset coordination.
6. Shared-asset governance for schema, APIs, events, permissions, routes, shared UI, and observability.
7. Risk register, foundation risks first.
8. Milestone alignment table using milestones only for acceptance.
9. Open questions and blockers with affected tasks and decision owners.
10. Next actions that can start now, blocked actions, and the next gate.

For Mode B, produce:

1. Validation summary and current unlock state.
2. Item-by-item gate evaluation.
3. Evidence inventory.
4. Failed and insufficient-evidence items.
5. Downstream impact.
6. Blocker ranking.
7. Recommended actions: rework, scope trim, or pause assessment.
8. Next concrete verification steps.

## Quality Checklist

Before finishing, verify:

- Foundation work is centralized in Stage 1.
- Every foundation layer has an objective gate.
- Business features start only after the foundation unlock gate.
- Milestones are used only for acceptance alignment.
- Each feature is a vertical slice.
- Parallel tasks have no hidden dependency.
- Shared-asset changes have governance.
- Existing assets are explicitly reused, migrated, replaced, retired, or tested.
- All gates have evidence.
- Unknown owners, dates, estimates, and decisions are marked `TBD`.
- Scope, assumptions, blockers, and stop conditions are visible.
