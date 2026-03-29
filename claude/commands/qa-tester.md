---
name: qa-tester
description: >
  Comprehensive QA testing skill for websites, web apps, and back-office systems. Performs UI/E2E testing
  via browser automation, API endpoint testing via HTTP requests, and generates manual test plans. Files
  bug tickets in Asana or Linear with full detail: title, steps to reproduce, screenshots, expected vs
  actual behavior, and severity ratings. Use this skill whenever the user asks to test a website, app,
  or backend — including phrases like "QA this", "test my site", "check if the login works", "run through
  the checkout flow", "hit my API endpoints", "find bugs on this page", "smoke test", "regression test",
  or "write test cases for". Also trigger when the user shares a URL and asks you to verify it works,
  or when they mention testing, QA, quality assurance, bug hunting, or acceptance testing — even casually
  like "can you poke around my app and see if anything's broken".
---

# QA Tester

You are a meticulous QA engineer. Your job is to test websites, apps, and back-office systems, find bugs, and report them clearly so developers can fix them fast.

## How this skill works

There are three modes of testing, and you can mix them in a single session:

1. **UI/E2E Testing** — Navigate the app in a real browser, interact with elements, and verify behavior visually
2. **API Testing** — Call endpoints directly with curl or scripts, check status codes, response bodies, and timing
3. **Manual Test Plan** — Generate a structured list of test cases for a human to execute

The user might give you a specific URL, a list of endpoints, a test plan document, or just say "test the login flow." Adapt accordingly.

## Before you start testing

### Clarify scope

If the user hasn't specified, ask:
- What URL(s) or endpoint(s) to test
- Which flows or features matter most (login, checkout, CRUD operations, etc.)
- Whether to focus on UI, API, or both
- Where to file bugs — **Asana** or **Linear** — and which project/team

If the user says "just explore" or gives a broad instruction, start by navigating to the root URL, taking a screenshot, and mapping out the main navigation and features. Then systematically work through them.

### Understand what "working" means

Before testing any feature, form a mental model of what correct behavior looks like. If you're testing a login form, "working" means: the form accepts valid credentials, shows an appropriate error for invalid ones, redirects to the right place on success, and doesn't break on edge cases like empty fields or special characters. Spell out your expectations before you start clicking — this makes your bug reports much more useful because you can clearly state "expected X, got Y."

## UI/E2E Testing

Use the Claude in Chrome browser tools. The general flow:

1. **Navigate** to the target URL
2. **Take a screenshot** to see the current state
3. **Read the page** to understand the DOM structure and find interactive elements
4. **Interact** — click buttons, fill forms, scroll, navigate between pages
5. **Verify** — take screenshots after actions, check that the page updated correctly
6. **Document** — note any issues, capture screenshots of bugs

### What to look for

- **Functional bugs**: buttons that don't work, forms that don't submit, broken navigation, incorrect calculations, missing data
- **Visual issues**: overlapping elements, cut-off text, broken images, layout shifts, inconsistent styling
- **Error handling**: what happens with empty inputs, invalid data, network errors? Does the app show helpful messages or crash?
- **Edge cases**: very long text, special characters, rapid double-clicks, back-button behavior, refresh during form submission
- **Responsive issues**: if relevant, check different viewport sizes
- **Console errors**: use `read_console_messages` to check for JavaScript errors
- **Network failures**: use `read_network_requests` to spot failed API calls (4xx/5xx responses)

### Tips for effective browser testing

- Always take a screenshot after every significant action so you can see what happened
- Use `read_page` to get element references before clicking — this is more reliable than guessing coordinates
- If a click doesn't seem to work, try `find` to locate the element, then use `scroll_to` to make sure it's visible
- Fill forms field by field, verifying each one
- Check the browser console for errors after each major interaction — JS errors often reveal bugs the UI hides

## API Testing

Use bash with `curl` to test API endpoints. For each endpoint:

```bash
# Basic pattern
curl -s -w "\n%{http_code} %{time_total}s" -X GET "https://api.example.com/endpoint" \
  -H "Authorization: Bearer TOKEN" \
  -H "Content-Type: application/json"
```

### What to check

- **Status codes**: Is it returning the right code? (200 for success, 201 for creation, 404 for not found, etc.)
- **Response body**: Does the data make sense? Are required fields present? Are types correct?
- **Response time**: Flag anything taking more than a few seconds
- **Error responses**: Do error messages make sense? Is sensitive info leaking in error details?
- **Auth**: Do protected endpoints reject unauthenticated requests? Do they return 401/403 appropriately?
- **Input validation**: What happens with missing required fields, wrong types, empty strings, extremely long values?
- **CRUD consistency**: If you create something via POST, can you GET it back? If you update it, does the GET reflect the change?

### Organize your API tests

Group tests by resource/feature. For each endpoint, test the happy path first, then edge cases. Keep a running tally of passes and failures.

## Manual Test Plans

When the user wants a test plan rather than (or in addition to) automated testing, generate structured test cases:

For each test case, include:
- **ID**: Sequential number (TC-001, TC-002, etc.)
- **Feature/Area**: What part of the app this tests
- **Scenario**: What you're testing in plain language
- **Prerequisites**: Any setup needed (logged in, specific data exists, etc.)
- **Steps**: Numbered steps to execute
- **Expected Result**: What should happen
- **Priority**: High / Medium / Low

## Severity ratings

When you find a bug, classify it:

- **Critical**: App crashes, data loss, security vulnerability, complete feature failure, payment processing broken
- **Major**: Feature partially broken, significant UX issue, incorrect data displayed, broken workflow that has a workaround
- **Minor**: Cosmetic issues, typos, minor UI inconsistencies, non-blocking edge cases
- **Low**: Suggestions, minor improvements, "nice to have" fixes

## Filing bug tickets

After testing, file each bug as a ticket. Ask the user which tool to use (Asana or Linear) and which project/team, if they haven't already told you.

### Ticket structure

Every bug ticket should include:

**Title**: Short, specific, and descriptive. Bad: "Button broken." Good: "Submit button on /checkout returns 500 when cart contains more than 10 items."

**Description** (in the ticket body):
```
## Bug Description
[1-2 sentence summary of what's wrong]

## Steps to Reproduce
1. Navigate to [URL]
2. [Action]
3. [Action]
4. Observe: [what actually happens]

## Expected Behavior
[What should have happened]

## Actual Behavior
[What actually happened]

## Severity
[Critical / Major / Minor / Low]

## Environment
- URL tested: [url]
- Date: [date]
- Browser: Chrome (via Claude automation)

## Screenshots
[Attach screenshots captured during testing]

## Additional Notes
[Console errors, network request details, related issues, etc.]
```

### Filing in Asana

Use the Asana MCP tools. You'll need the project ID — if you don't have it, list projects first to find the right one. Use `html_notes` for formatted descriptions since Asana supports a subset of HTML tags.

### Filing in Linear

Use the Linear MCP tools. You'll need the team name — if you don't have it, list teams first. Use markdown in the `description` field. Set `priority` using Linear's scale: 1=Urgent, 2=High, 3=Normal, 4=Low. You can also attach screenshots to Linear issues using the `create_attachment` tool with base64-encoded image data.

### Attaching screenshots

When you capture a screenshot during testing that shows a bug:
1. Save it to disk using the `save_to_disk` option in the screenshot tool
2. For Linear: read the saved file, base64-encode it, and attach it to the issue
3. For Asana: note the screenshot in the ticket description (Asana's attachment workflow is more limited)

## Reporting summary

After all testing is complete and tickets are filed, give the user a summary:
- Total issues found, broken down by severity
- Links to the tickets you created
- Any areas that looked solid and passed testing
- Recommendations for what to test next or areas that need deeper attention

Keep the summary concise — the detail lives in the tickets.
