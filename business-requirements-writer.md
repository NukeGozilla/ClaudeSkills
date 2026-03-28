---
name: business-requirements-writer
description: >
  Use this skill whenever the user wants to write, draft, or structure a Business
  Requirement (BR) document for a product feature or system. Triggers include:
  "write a BR", "business requirement for [feature]", "BR doc", "feature spec",
  "product requirement", "write requirements for", "spec out [feature]", or any
  request to define what a feature should do before engineering begins. Also trigger
  when the user describes a feature idea and needs it formalized into structured
  requirements. Always use this skill when the output is a business-facing
  requirements document — even if the user just says "help me define [feature]"
  or "I need to spec this out". Do NOT use for technical specs, API docs, or
  engineering implementation plans — this is the WHAT and WHY layer, not the HOW.
---

# Business Requirements Writer

## Purpose
Produce a structured, complete Business Requirements document that a tech lead can decompose into Functional Requirements (FR) and Technical Requirements (TR) — without needing the CPO in the room.

Every BR document must be specific enough that:
1. A tech lead can derive FR/TR tickets from it
2. A designer can start wireframing from the user flows
3. A QA lead can write test cases from the acceptance criteria
4. A stakeholder can understand scope and phasing at a glance

---

## When This Skill Triggers

Produce the full BR document when the user:
- Describes a feature and asks to formalize it
- Says "write a BR", "spec this out", "define requirements for [X]"
- Provides raw feature ideas that need structure
- Asks for a requirements doc for handoff to engineering

---

## Step 0: Intake — Before Writing Anything

Before generating the BR, assess whether the user's input has enough clarity to produce a useful document.

**Minimum required inputs** (extract from context or ask):
1. **What is the feature?** (even a rough description)
2. **Who uses it?** (at least one user group)
3. **What problem does it solve?** (business or user pain point)

**If any of the three are missing**, ask a maximum of 2 clarifying questions before proceeding. Frame questions as multiple choice when possible.

**If all three are present**, proceed immediately — do not ask permission.

**If input is vague**, write the BR AND flag assumptions clearly with ⚠️ markers. Don't block on ambiguity — produce a draft the user can correct.

---

## Output Structure

Print the entire BR directly in chat. Follow this exact section order:

---

### Section 1: Problem Statement

**Purpose:** Ground everyone on WHY this feature exists.

Write 2-4 sentences covering:
- What user pain or business gap this addresses
- What happens if we DON'T build this (cost of inaction)
- How this connects to broader product/business goals

**Rules:**
- No feature descriptions here — this is purely about the problem
- Must be understandable by a non-technical stakeholder
- If the user didn't articulate the problem clearly, infer it and mark with ⚠️

---

### Section 2: User Groups

**Purpose:** Define WHO is affected before designing flows.

Present as a table:

| User Group | Role Description | Access Level | Key Need |
|---|---|---|---|
| [e.g., End Customer] | [what they do] | [view/edit/admin] | [primary need from this feature] |

**Rules:**
- Include ALL user groups that interact with this feature — frontend AND backend
- Include system actors if relevant (e.g., "Cron Job", "Webhook Listener")
- Minimum 2 user groups (if truly single-user, explain why)

---

### Section 3: User Stories

**Purpose:** Translate user needs into actionable stories that drive development.

Write one user story per user group using this format:

> **US-[XX]:** As a **[user group]**, I want to **[action]**, so that **[outcome/value]**.

**Rules:**
- One story per user group minimum
- A user group may have multiple stories if their needs are distinct
- The "so that" clause must state business or user VALUE — not restate the action
- Bad: "so that I can submit the form" → Good: "so that my request is logged and trackable"

---

### Section 4: User Flow

**Purpose:** Map the step-by-step journey from trigger to completion.

Present as a numbered sequence, annotated with the acting user group:

```
Step 1: [User Group] → [Action] → [System Response]
Step 2: [User Group] → [Action] → [System Response]
...
```

**Decision points:** Mark with 🔀 and show both paths:
```
Step 3: 🔀 Decision: [condition]
  → YES: [what happens]
  → NO: [what happens]
```

**Rules:**
- Every step must specify WHO is acting
- Include system-initiated steps (notifications, auto-calculations, etc.)
- Cover the happy path FIRST, then note error/exception paths
- If flows are independent per user group → create separate flows with clear headers
- If flows intersect (e.g., customer submits → admin approves) → one combined flow with role annotations

---

### Section 4a: 📊 User Flow Diagram (SVG)

**Purpose:** Visual representation of the user flow(s) from Section 4.

**Generation logic:**
1. Analyze the user groups and flows from Section 4
2. **If flows are interconnected** (one user's output triggers another user's input) → generate ONE combined flow diagram with swimlanes per user group
3. **If flows are fully independent** (no handoff between groups) → generate SEPARATE flow diagrams, one per user group
4. Include decision diamonds for 🔀 branch points
5. Use color coding to distinguish user groups

**Diagram requirements:**
- Start/End nodes clearly marked
- Decision points as diamonds
- User group labels on each action
- System actions visually distinct from user actions
- Clean layout, left-to-right or top-to-bottom flow

---

### Section 5: Business Requirements

**Purpose:** The core deliverable. Each BR is a discrete, testable requirement.

Present as a numbered list:

**BR-[XX]: [Requirement title]**
- **Description:** [1-2 sentences — what the system must do]
- **Priority:** 🔴 Must-Have | 🟡 Should-Have | 🟢 Nice-to-Have
- **User Group(s):** [which groups this affects]
- **Measurability:** [how you verify this is met — quantitative if possible]

**Rules:**
- Each BR must be independently testable — if you can't write an acceptance criterion for it, it's too vague
- Use active voice: "The system SHALL [verb]..." or "The user SHALL be able to [verb]..."
- One requirement per BR — if it has "and" connecting two distinct behaviors, split it
- Order by logical dependency (BR-01 should not depend on BR-05)
- Aim for 5-15 BRs per feature. If you have more than 15, the feature scope is likely too large — flag this

---

### Section 5a: 📊 System Diagram (SVG)

**Purpose:** Show how the feature's modules/components connect to each other at an architecture level.

**Generation logic:**
1. Extract modules, services, and data stores from the BRs
2. Map which BRs belong to which module
3. Show data flow / dependencies between modules with directional arrows
4. Label each module box with its associated BR IDs (e.g., "Payment Module — BR-03, BR-07")

**Diagram requirements:**
- Boxes = modules/components/services
- Arrows = data flow or dependency direction
- BR IDs annotated on relevant modules
- External systems (3rd party APIs, existing services) shown with dashed borders
- Database/storage shown with cylinder shapes
- Clean, readable layout — no crossing arrows if avoidable

---

### Section 6: Acceptance Criteria

**Purpose:** Define what "done" looks like for each BR. QA writes test cases from this.

Group by BR, with each criterion assigned an ID:

**BR-[XX]: [Title]**
- ✅ **AC-[XX]a:** [Verifiable condition 1]
- ✅ **AC-[XX]b:** [Verifiable condition 2]

**Rules:**
- Every BR must have at least 1 acceptance criterion — no exceptions
- Use format: "GIVEN [context], WHEN [action], THEN [result]" for complex conditions
- Simple conditions can use plain statements
- Include negative cases: "System SHALL NOT allow [X] when [Y]"
- Avoid subjective language ("user-friendly", "fast", "intuitive") — replace with measurable criteria

---

### Section 7: Do / Don't / Edge Cases

**Purpose:** Guardrails and boundary conditions to prevent scope creep and implementation mistakes.

Present in three sub-sections:

**✅ Do:**
- [Implementation guidance that should be followed]

**❌ Don't:**
- [Anti-patterns, common mistakes, scope boundaries]

**⚠️ Edge Cases:**
- [Boundary conditions, unusual scenarios, error states to handle]

**Rules:**
- Minimum 3 items per sub-section
- Edge cases must describe the scenario AND the expected behavior
- Don'ts should prevent the most likely misinterpretations of the BRs

---

### Section 8: Dependencies & Integration Points

**Purpose:** Map what this feature touches outside its own scope.

Present as a table:

| ID | Dependency | Type | Impact | Status |
|---|---|---|---|---|
| DEP-[XX] | [system/feature/team] | Blocks / Blocked-by / Integrates-with | [what breaks without it] | Known / Needs Investigation |

**Rules:**
- Include internal dependencies (other features, teams) AND external (3rd party APIs, data sources)
- Flag anything with "Needs Investigation" status — these are risk items
- If no dependencies exist, explicitly state "No external dependencies identified" (this is rare and worth flagging)

---

### Section 9: Phase Breakdown

**Purpose:** Suggest how to sequence the BRs across phases for incremental delivery.

Present as:

**PH-01: [Phase Name] — [Goal of this phase]**
BR-01 → BR-06 → BR-07 → BR-02
*Rationale:* [Why this sequence — what becomes usable after this phase]

**PH-02: [Phase Name] — [Goal of this phase]**
BR-03 → BR-08 → BR-04
*Rationale:* [Why this sequence]

**Rules:**
- Phase 1 must deliver a usable, testable slice of functionality (MVP mindset)
- Sequence within a phase follows dependency order
- Each phase has a clear rationale — not arbitrary grouping
- Flag BRs that could be cut entirely without breaking the core feature (mark with 💡 "Optional — can defer indefinitely")
- Maximum 3-4 phases. If more are needed, the feature scope is too large — flag this.

---

## Quality Checklist (Self-Validation)

Before outputting the BR, verify:

1. ✅ Every user group has at least one user story (US-XX)
2. ✅ Every BR has at least one acceptance criterion (AC-XXa)
3. ✅ No BR contains "and" connecting two separate behaviors (split if so)
4. ✅ User flow covers happy path AND at least one error/exception path
5. ✅ Phase 1 delivers a usable, testable slice
6. ✅ System diagram references BR IDs on module labels
7. ✅ No subjective or unmeasurable language in acceptance criteria
8. ✅ Cross-Reference Map has zero orphaned entities (every BR mapped to US, AC, and PH)
9. ✅ Ticket Metadata Index has all fields populated for every BR
10. ✅ Screen Map covers every flow step

---

## Assumption Handling

When the user's input is incomplete:
- Write the BR with best-judgment assumptions
- Mark every assumption with: **⚠️ Assumption:** [what was assumed and why]
- Group all assumptions in a summary at the end if there are more than 3
- Do NOT block output waiting for clarification on non-critical items

---

## Examples

### Good BR:
**BR-03: Order Total Auto-Calculation**
- **Description:** The system SHALL automatically calculate the order total including line items, tax, and applicable discounts whenever an item is added, removed, or quantity is changed.
- **Priority:** 🔴 Must-Have
- **User Group(s):** End Customer, Admin (manual order creation)
- **Measurability:** Calculated total matches expected value within ±$0.01 across all test scenarios.

### Bad BR:
**BR-03: Handle pricing**
- **Description:** The system should manage pricing in a user-friendly way.
- **Priority:** High
- ❌ Too vague — can't derive FR/TR from this. No measurability. Subjective language.

---

## SVG Generation Guidelines

When generating the User Flow and System Diagram SVGs via Visualizer:

**User Flow SVG:**
- Use rounded rectangles for actions
- Diamonds for decision points
- Color-code by user group (use consistent palette)
- Swimlanes for combined flows with multiple user groups
- Start = filled circle, End = filled circle with border

**System Diagram SVG:**
- Rectangles for internal modules (solid border)
- Rectangles with dashed border for external systems
- Cylinders for databases/storage
- Directional arrows for data flow
- BR IDs inside or adjacent to module labels
- Group related modules visually

---

## Section 10: For AI Readers

**Purpose:** Machine-readable appendix that enables Claude (or any AI) to auto-generate tickets (Linear/Asana), prototypes, and test cases directly from this document. Humans can ignore this section.

This section is ALWAYS generated as the final section of every BR document.

---

### 10a: ID Cross-Reference Map

Map every entity to its related entities. This is the relationship graph Claude reads to understand how the BR connects.

Format:

```
=== CROSS-REFERENCE MAP ===

USER STORIES → BUSINESS REQUIREMENTS
US-01 → BR-01, BR-03
US-02 → BR-02, BR-04, BR-05

BUSINESS REQUIREMENTS → ACCEPTANCE CRITERIA
BR-01 → AC-01a, AC-01b
BR-02 → AC-02a, AC-02b, AC-02c
BR-03 → AC-03a

BUSINESS REQUIREMENTS → DEPENDENCIES
BR-04 → DEP-01
BR-07 → DEP-02, DEP-03

BUSINESS REQUIREMENTS → PHASES
PH-01: BR-01, BR-06, BR-07, BR-02
PH-02: BR-03, BR-08, BR-04

FLOW STEPS → BUSINESS REQUIREMENTS
Step 1 → BR-01
Step 3 → BR-03, BR-04
Step 5 → BR-07
```

**Rules:**
- Every BR must appear in at least one US mapping
- Every BR must appear in at least one AC mapping
- Every BR must appear in exactly one PH (phase) mapping
- Orphaned entities (not mapped to anything) = error — flag and fix

---

### 10b: Ticket Metadata Index

Structured block per BR, formatted for direct ticket generation in Linear or Asana.

Format:

```
=== TICKET METADATA INDEX ===

[BR-01]
title: [Action-oriented title starting with a verb]
description: [1-2 sentence description from Section 5]
priority: [Must-Have | Should-Have | Nice-to-Have]
estimate: [S | M | L | XL]
labels: [comma-separated: backend, frontend, integration, design, infrastructure]
user_groups: [comma-separated affected groups]
phase: PH-[XX]
depends_on: [BR-XX, BR-XX or "none"]
blocked_by: [DEP-XX or "none"]
acceptance_criteria: [AC-XXa, AC-XXb]
user_stories: [US-XX, US-XX]

[BR-02]
title: ...
...
```

**Estimate sizing guide:**
- **S** = < 1 day of dev work, single component, no integration
- **M** = 1-3 days, may touch 2 components, light integration
- **L** = 3-5 days, multiple components, integration required
- **XL** = 5+ days, cross-system, likely needs decomposition into sub-tickets — flag this

**Rules:**
- Title MUST start with a verb (Build, Implement, Create, Design, Configure, Enable, Add, Fix)
- Every field must be populated — no blanks
- If estimate is XL, add a note: `⚠️ Consider splitting into sub-tickets`
- Labels must reflect the primary domain of work, not the feature name

---

### 10c: Screen Map

One line per user flow step, mapping to the screen/page/state where it occurs. Claude uses this to scaffold prototypes.

Format:

```
=== SCREEN MAP ===

Step 1 → Screen: [Screen Name]
Step 2 → Screen: [Screen Name]
Step 3 → Screen: [Screen Name] | State: [state after action]
Step 4 → Screen: [Screen Name] | State: [state after action]
Step 5 → Screen: [Modal/Overlay Name] (over [Parent Screen])
...
```

**Rules:**
- Every flow step gets exactly one screen mapping
- Modals/overlays specify parent screen in parentheses
- System-only steps (no UI) → `Screen: [System/Background Process]`
- Reuse screen names when multiple steps happen on the same screen
- State annotations only when the step changes the visible state of the screen
- Keep screen names short and descriptive — these become prototype page titles
