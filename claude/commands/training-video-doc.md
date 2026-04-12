---
name: training-video-doc
description: >
  Produces a step-by-step training document with embedded screenshots by
  browsing a live web application using Playwright. Use this skill whenever
  the user wants to document an app feature for training purposes, generate
  step-by-step instructions from a real UI, or capture screenshots of an
  actual app flow. Trigger when user says things like "document this feature",
  "create a training guide for", "walk through how to", or "generate a
  tutorial for [feature]".
---

# Training Video Documentation Skill

This skill drives a real web application using Playwright, captures screenshots
at each meaningful step, and produces a clean step-by-step guide with
annotated screenshots — ready to hand to a video producer or use directly
as a training reference.

---

## Phase 1: Interview the User

Before touching the browser, ask these questions **one at a time**.
Wait for each answer before asking the next.

1. **App URL** — What is the URL of the app? Is it local (localhost) or live?
2. **Auth** — Do you need to log in? If yes, please provide test credentials,
   or navigate to the authenticated state yourself and tell me when ready.
3. **Feature** — What specific feature or objective should this tutorial cover?
   (e.g. "how to generate a shipping label", "how to process a refund")
4. **Starting point** — What page or section should I navigate to first?
5. **Audience** — Who is the reader? (e.g. new staff, merchant admin, end user)
   This affects the language used in the instructions.
6. **App name** — What is the name of the application as it should appear
   in the output document?

Once all six are answered, confirm:
> "Got everything I need. Running the browser now — I'll pause and ask
> before any unclear or irreversible actions."

---

## Phase 2: Browser Setup

Run setup script first:

```bash
node setup.js
```

This installs Playwright and creates the output folder structure:

```
output/
├── screenshots/    ← all captured screenshots saved here
└── training-doc.md ← final step-by-step guide
```

Then use `crawler.js` as the base to navigate and screenshot the app.

---

## Phase 3: Document the Flow

Walk through the feature step by step using Playwright.

### Screenshot Rules

- Capture **before** the action — shows what the user should look at
- Capture **after** the action — shows the result / state change
- Name sequentially: `step-01-before.png`, `step-01-after.png`
- Viewport: 1440×900
- Highlight the key UI element with a red outline before screenshotting:

```javascript
// Highlight target element
await page.evaluate((selector) => {
  const el = document.querySelector(selector);
  if (el) el.style.outline = '3px solid red';
}, selector);

await page.screenshot({ path: filePath });

// Remove highlight immediately after
await page.evaluate((selector) => {
  const el = document.querySelector(selector);
  if (el) el.style.outline = '';
}, selector);
```

### What counts as a meaningful step

Capture and document:
- Arriving at a new page or section
- Clicking a significant button, tab, or link
- Filling in a form field (before = empty, after = filled)
- A loading / processing state the user must wait through
- A success, warning, or error message appearing
- Any modal, drawer, or overlay opening
- Any state change that would confuse a first-time user

### When to stop and ask

Pause and ask the user before:
- Any UI element whose purpose is ambiguous
- A dropdown or field with multiple options (ask which to select for the demo)
- Any irreversible action (delete, submit, charge, send)
- An unexpected error — ask if it should be included or skipped
- A page requiring data not covered in the interview

---

## Phase 4: Write the Output Document

After completing the full flow, write `output/training-doc.md`:

```markdown
# [App Name] — [Feature Name]
## Step-by-Step Training Guide

**Audience:** [from interview]
**Feature:** [feature name]
**Date:** [today's date]

---

## What This Guide Covers

[2–3 sentences. Plain language. What the feature does, when a user
would use it, and what they will be able to do after following this guide.]

---

## Before You Start

[List any prerequisites — permissions needed, data that must exist,
pages to navigate to first. If none, write "No prerequisites."]

---

## Steps

---

### Step 1: [Short imperative title]

![Step 1](screenshots/step-01-before.png)

**Action:** [Exactly what to click, type, or select. Name the UI element
exactly as it appears on screen. Imperative voice. One action per step.]

![Step 1 result](screenshots/step-01-after.png)

**Result:** [What the user sees after completing the action. Describe the
visual change so they know they did it correctly.]

---

### Step 2: [Title]

![Step 2](screenshots/step-02-before.png)

**Action:** [...]

![Step 2 result](screenshots/step-02-after.png)

**Result:** [...]

---

[Repeat for every step]

---

## You're Done

[One sentence confirming what the user has accomplished.]

---

## Common Mistakes

[3–5 bullet points based only on things actually observed in the UI.
Confusing labels, easy-to-miss buttons, steps people skip, etc.]

- [Mistake and how to avoid it]
- [Mistake and how to avoid it]
- [Mistake and how to avoid it]

---

## Screenshots Reference

| Step | Before | After |
|------|--------|-------|
| Step 1 — [Title] | step-01-before.png | step-01-after.png |
| Step 2 — [Title] | step-02-before.png | step-02-after.png |
```

---

## Phase 5: Final Checklist

Before delivering to the user verify:

- [ ] Every step has a before AND after screenshot
- [ ] Screenshot filenames exactly match the reference table
- [ ] Every UI element name matches what appears on screen verbatim
- [ ] Each step contains exactly one action — split if there are two
- [ ] Loading / processing states are documented as their own steps
- [ ] Common Mistakes section is based on observed UI, not guesswork
- [ ] The doc can be followed by someone who has never opened the app

Then tell the user:
> "Done. Your training guide is at output/training-doc.md and screenshots
> are in output/screenshots/. Keep both folders together — the image
> paths are relative. Want me to document another feature?"

---

## Tips for Claude Running This Skill

- **Be literal** — copy button and field labels exactly as shown on screen
- **One action per step** — if a step feels long, split it into two
- **Loading states count** — a spinner or "Processing…" screen is a step
- **Ask early** — ambiguous UI? Ask before clicking, not after
- **Red outlines help** — always highlight the target element before screenshotting
- **Common Mistakes must be observed** — never invent them from assumptions
