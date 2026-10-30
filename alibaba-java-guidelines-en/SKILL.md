---
name: alibaba-java-guidelines-en
description: Apply P3C-aligned team Java rules when generating, editing, reviewing, or validating Java Spring Boot backend code, including controllers, services, managers, repositories or mappers, DTOs, DOs, exceptions, utilities, and tests; do not apply to non-Java work.
metadata:
  version: "1.2"
  changelog:
    - version: "1.2"
      date: "2026-10-30"
      summary: "Clarified terminology, exceptions, Java 17 records, validation, time mapping, serialization, locking, SQL, mocks, and accepted-risk delivery."
    - version: "1.1"
      date: "2026-10-30"
      summary: "Added stable rule IDs, structured review output, performance and transaction rules, enum rules, and Error handling boundaries."
    - version: "1.0"
      date: "2026-10-30"
      summary: "Initial English version aligned with the local Alibaba Java P3C Songshan skill."
---

# Alibaba Java Coding Guidelines (P3C Songshan Edition)

## Scope and Priority

- `JAVA-SCOPE-01` This skill applies to generating, modifying, fixing, reviewing, and validating Java Spring Boot backend code and its unit tests. It does not apply to Kotlin, Android, frontend, or standalone SQL scripts.
- `JAVA-SCOPE-02` Always follow the current repository's `AGENTS.md`, project layering, dependency versions, and existing code style in addition to this skill. If rules conflict, preserve project standards, public contracts, and compatibility first, and explain the tradeoff to the user.
- `JAVA-SCOPE-03` New code must comply with these rules directly. When modifying existing code, keep the diff minimal and behavior equivalent; do not opportunistically refactor, format unrelated code, or change external behavior.
- `JAVA-SCOPE-04` Determine the Java version from the project's build configuration. If it is still unknown, use Java 8-compatible constructs. On Java 17, records, sealed types, switch expressions, and pattern matching for `instanceof` are allowed when they simplify the code and are supported by the project toolchain. Prefer records for read-only `DTO` and `Resp` objects; do not force records when an existing project contract requires mutable objects. Preserve surrounding style when editing existing files and do not enable preview features.
- `JAVA-SCOPE-05` Perform a self-check against these rules before delivery and fix violations first. Only explain a deviation when a project standard, Java version, or existing contract makes compliance impossible.

## Naming and Formatting

- `JAVA-NAMING-01` Use all-lowercase package names. Do not use pinyin or ambiguous abbreviations.
- `JAVA-NAMING-02` Use UpperCamelCase for classes, interfaces, and enums. Use lowerCamelCase for methods, variables, and parameters.
- `JAVA-NAMING-03` Name `static final` constants in `UPPER_SNAKE_CASE`, for example `ORDER_STATUS_SUCCESS`.
- `JAVA-NAMING-04` Use business-model suffixes according to their purpose without mixing them: `DO`, `DTO`, `Req`, `Resp`, `BO`, and `Query`.
- `JAVA-NAMING-05` Name types such as `Controller`, `Service`, `Repository`, `Mapper`, `Configuration`, `Converter`, `Util`, and `Exception` according to framework semantics and existing project conventions.
- `JAVA-NAMING-06` Do not prefix interface names with `I`.
- `JAVA-NAMING-07` Use 4 spaces for indentation and never use tabs. Use the project-configured line-length limit; when none is configured, keep lines to 120 characters or fewer.
- `JAVA-NAMING-08` Use K&R brace style. Even a single-line `if` statement must use braces.
- `JAVA-NAMING-09` Order class members as follows: static constants, fields, constructors, static methods, instance methods, getters and setters, then private utility methods.
- `JAVA-NAMING-10` Do not use wildcard imports. Import concrete classes and remove unused imports.

## Method and Type Design

- `JAVA-METHOD-01` Start method names with a verb, keep each method focused on one responsibility, and aim to keep methods within 80 lines.
- `JAVA-METHOD-02` When a business interface method on a Controller, Service, or similar component has more than 3 parameters, wrap them in a `Req`, `DTO`, or `Query`. Overrides, framework callbacks, genuinely necessary test constructors, simple query methods with independent filter parameters, and private internal helper methods are exceptions.
- `JAVA-METHOD-03` Add `@Override` to every overridden method.
- `JAVA-METHOD-04` Write Javadoc for every new public method, covering its responsibility, parameters, return value, and expected business exceptions. Use the project's documentation language consistently and do not mix Chinese and English arbitrarily. Getters, setters, `toString`, `@Override` methods, test methods, and semantically clear one-line delegating methods are exceptions.
- `JAVA-METHOD-05` Use implementation comments only for non-obvious business constraints, boundary conditions, defensive logic, transaction or outbox choices, and external-contract quirks; do not restate syntax.
- `JAVA-METHOD-06` Never return `null` for a collection. Prefer an immutable empty collection such as `Collections.emptyList()` for interface returns. If the caller contract requires a mutable collection, return an explicit mutable empty collection such as `new ArrayList<>()`.
- `JAVA-METHOD-07` Prefer `Objects.equals(a, b)` for equality checks. When calling `equals` directly, place the constant or already null-checked object on the left.
- `JAVA-METHOD-08` Always override `hashCode` when overriding `equals`.
- `JAVA-METHOD-09` Represent money with `BigDecimal`, compare it with `compareTo`, and never compare it with `equals`.
- `JAVA-METHOD-10` Use `java.time` for new standalone classes, methods, or APIs. When maintaining an existing `Date` or `Calendar` contract, follow the surrounding types; never replace an external contract merely to normalize it.
- `JAVA-METHOD-11` Close manually opened IO, streams, and database connections with try-with-resources or an equivalent mechanism. Do not manually close resources managed by Spring, MyBatis, or another framework.
- `JAVA-METHOD-12` Do not use business magic values; extract constants or enums. Framework-fixed values and mathematical constants without business semantics are exceptions.
- `JAVA-METHOD-13` A business enum crossing an API or storage boundary must define a stable business code and an explicit parse factory; do not use `ordinal`, reflective name parsing, or `toString` as the external contract unless an existing contract requires it.
- `JAVA-METHOD-14` Prefer guard clauses and early returns to reduce nesting.
- `JAVA-METHOD-15` Never remove existing null checks, boundary validation, exception handling, or fallback logic unless the task explicitly requires it.
- `JAVA-METHOD-16` Validate API request objects at the boundary with field-specific Bean Validation constraints such as `@NotNull`, `@NotBlank`, `@NotEmpty`, `@Size`, and `@Pattern`, using the project's validation groups where applicable; do not rely only on later generic null checks.
- `JAVA-METHOD-17` Before unboxing wrapper parameters or return values, null-check nullable `Integer`, `Long`, `Double`, and similar wrapper types, then apply business boundary checks before arithmetic, parsing, or collection access.
- `JAVA-METHOD-18` Keep one `java.time` representation throughout a business boundary. Map `LocalDateTime` to SQL `DATETIME`, `LocalDate` to `DATE`, and `LocalTime` to `TIME` where the database supports them; do not alternate between timestamp and date-time semantics for the same field.
- `JAVA-METHOD-19` Never store timestamps as strings or parse them with ad hoc formats. Use managed converters, formatters, or serialization configuration so storage and API formats remain explicit and consistent.

## Layering Constraints

- `JAVA-LAYER-01` Respect existing project layering. If a project has no Manager layer, do not add one solely to satisfy layering.
- `JAVA-LAYER-02` Controllers only receive parameters, perform validation through the project's existing `@Valid` or `@Validated` usage, convert objects, and return the unified response. They must not contain business rules.
- `JAVA-LAYER-03` Services own business rules and transactions. For write operations, use `@Transactional(rollbackFor = Exception.class)` as required by project standards and keep transaction scope as small as possible.
- `JAVA-LAYER-04` Where a Manager layer exists, it contains only reusable business capabilities, third-party integrations, or cross-business-domain orchestration. It must not bypass Services and be exposed directly to Controllers.
- `JAVA-LAYER-05` Repositories and Mappers only access data and must not contain business rules.
- `JAVA-LAYER-06` Never return a DO directly to the frontend. Convert explicitly between DOs and `Req`, `Resp`, or `DTO` objects.
- `JAVA-LAYER-07` Serialize only `Resp`, `DTO`, or other API-boundary objects, never a DO. Centralize date and time serialization formats in framework or converter configuration; do not scatter presentation-format annotations across domain or persistence objects.

## Exceptions, Logging, and Security

- `JAVA-EXCEPTION-01` Catch specific exception types and never swallow exceptions. Global exception handlers, asynchronous boundaries, and task boundaries may catch `Exception` as a last resort, but they must log the complete exception and then rethrow it, wrap it, or execute an explicit fallback. A global handler must map the failure to the project's error response and status; never return generic success or silently suppress a business failure.
- `JAVA-EXCEPTION-02` Do not catch `Error` or `Throwable` at business boundaries. Only framework bootstrap or top-level worker boundaries may handle them with explicit justification, containment, and recovery behavior.
- `JAVA-EXCEPTION-03` Throw the project's existing custom business exception for business failures. Never use `new RuntimeException` to represent a business error.
- `JAVA-EXCEPTION-04` Logs must include business context such as `orderId` or `userId` and pass the exception object as the last argument. Never log only `e.getMessage()`.
- `JAVA-EXCEPTION-05` Do not use exceptions to control normal business branches.
- `JAVA-EXCEPTION-06` Do not use `System.out` for debugging output.
- `JAVA-EXCEPTION-07` Never hard-code secrets, passwords, or tokens. Mask sensitive fields returned to the frontend, such as phone numbers and identification numbers, according to project requirements.

## MyBatis and SQL

- `JAVA-SQL-01` Never use `select *`; always specify the queried columns.
- `JAVA-SQL-02` Use `#{}` for SQL parameters. Never build SQL through string concatenation.
- `JAVA-SQL-03` For dynamic table names, column names, or sort fields, prefer static SQL branches or a `<choose>` mapping. If `${}` is genuinely required, allow only controlled identifiers from an enum or allowlist; never accept unrestricted user input.
- `JAVA-SQL-04` User-facing business lists and backend data lists must use physical pagination. Deterministic bounded collections such as dictionaries, configuration, and menus may be fetched in one query, but must have stable ordering and must not evolve into unbounded queries.
- `JAVA-SQL-05` Full exports must never load all data at once. Use streaming, cursors, or batching, and explain memory and timeout risks.
- `JAVA-SQL-06` Do not use a leading-wildcard `LIKE '%keyword%'` in ordinary indexed queries. Use a normal prefix query, full-text search, search infrastructure, or an explicitly approved unbounded scan design.
- `JAVA-SQL-07` Keep Java and SQL predicate and join types compatible, avoid wrapping indexed columns in functions or casts, and do not add indexes without query evidence, cardinality context, a migration, and a rollback plan.
- `JAVA-SQL-08` Exclude large text, binary, JSON, and other heavy columns from ordinary queries unless the use case needs them; fetch them explicitly with a bounded projection or detail query.

## Performance, Resources, and Transactions

- `JAVA-PERF-01` In loops, build strings with `StringBuilder`; set its initial capacity when the final size is known or can be estimated cheaply.
- `JAVA-PERF-02` When creating a collection whose expected size is known, pass the initial capacity where the concrete collection supports it, such as `new ArrayList<>(expectedSize)`.
- `JAVA-PERF-03` Do not issue database queries or remote calls inside loops. Batch the data first, use a set-based query, or restructure the flow so repeated calls cannot scale with list size; pure in-memory computation in a loop is not prohibited by this rule.
- `JAVA-PERF-04` Do not load external resources in static initialization blocks. Inject configuration or resources, or initialize them lazily with explicit failure handling and lifecycle ownership.
- `JAVA-TRANS-01` Keep remote calls outside database transactions. If a transaction and external effect must be consistent, use the project's existing transactional outbox or equivalent committed-state pattern.
- `JAVA-TRANS-02` Send messages or trigger external side effects only after the local transaction commits, or through the project's approved transactional-message pattern; do not rely on best-effort calls inside a transaction.

## Concurrency

- `JAVA-THREAD-01` Business code must not create threads directly with `new Thread`; reuse the project's existing thread pools where possible.
- `JAVA-THREAD-02` When creating a thread pool, use `ThreadPoolExecutor` with explicit capacities, or a Spring `ThreadPoolTaskExecutor` configured with a bounded queue, named thread factory, and rejection policy.
- `JAVA-THREAD-03` Do not use queue-capacity-hiding factory methods such as `Executors.newFixedThreadPool` or `newSingleThreadExecutor`.
- `JAVA-THREAD-04` Define the thread pool lifecycle, rejection policy, and task exception handling explicitly.
- `JAVA-THREAD-05` For shared mutable state, document the visibility and atomicity requirement. Use `volatile` only for visibility, not compound atomic operations; protect compound mutations with `synchronized` or an explicit lock and keep the critical section minimal.
- `JAVA-THREAD-06` Do not execute database queries, remote calls, or other blocking IO inside a lock. Fetch or prepare data outside the critical section, then apply the smallest state transition under the lock.

## Unit Tests

- `JAVA-TEST-01` End test class names with `XxxTest`. Name test methods after business behavior and preserve the existing project style.
- `JAVA-TEST-02` Tests must be repeatable and order-independent and must use explicit assertions.
- `JAVA-TEST-03` Avoid `Thread.sleep` for synchronization. Do not introduce uncontrolled random values, current time, or external state that make tests unstable.
- `JAVA-TEST-04` When fixing a defect, first add a test that reproduces the issue, then implement the fix.
- `JAVA-TEST-05` With Mockito, mock collaborator boundaries needed for the behavior under test and verify meaningful interactions. Avoid static, final, and constructor mocks except for tightly scoped legacy seams where no ordinary seam can be introduced in the current task.
- `JAVA-TEST-06` Unit tests must not connect to a real database, MQ, Redis, or other external system. Use integration tests with Testcontainers or the project's approved embedded database; H2 is acceptable only when its compatibility limitations are understood and recorded.

## Review and Delivery Output

- `JAVA-CHECK-01` Check every rule in this skill before producing output. Never emit noncompliant code first and then offer to fix it.
- `JAVA-CHECK-02` Delivered Java code must pass a syntax self-check. When project files are involved, run the available compile, test, or static-analysis commands required by the task.
- `JAVA-CHECK-03` Rule IDs are stable contract identifiers. Never renumber or reuse them; retire a rule by marking it deprecated instead.
- `JAVA-CHECK-04` For an explicit review, lint, or audit request, output a structured report after examination:

  ```markdown
  ## Java Guideline Review

  Scope: <files or modules examined>
  Result: <pass | findings | blocked> (<P1 count> P1, <P2 count> P2, <P3 count> P3)

  | Rule ID | Location | Severity | Finding | Suggested fix | Status |
  | --- | --- | --- | --- | --- | --- |
  | JAVA-XXX-NN | path:line | P1/P2/P3 | violation or blocker | concrete fix | fixed/unresolved/accepted-risk/not-applicable |
  ```

  Use `P1` for correctness, data integrity, security, or production-blocking issues; `P2` for rules that should be fixed in the current change; `P3` for low-risk improvements. For generation or modification tasks, fix violations before delivery and only report unresolved compatibility conflicts instead of replacing fixes with a report. If a fix would break an existing public contract, require a broad unrelated legacy refactor, or violate minimal-diff scope, mark it `accepted-risk`, state the constraint, affected scope, and follow-up condition instead of forcing the change.
