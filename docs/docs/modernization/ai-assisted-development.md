---
layout: default
title: AI-Assisted Development with IBM Bob
---

# AI-Assisted Development with IBM Bob

IBM Bob is an AI coding assistant built for enterprise development. On a mainframe codebase like CBSA, Bob compresses the developer learning curve from weeks to hours — and accelerates every phase of the development lifecycle.

<div class="callout callout-green">
<strong>Key message:</strong> Bob does not replace COBOL developers. It makes every developer on the team — including those who have never seen COBOL before — immediately productive on an IBM Z codebase.
</div>

## What Bob Can Do with CBSA

<div class="value-cards">
  <div class="value-card">
    <div class="value-card-icon">
      <svg viewBox="0 0 32 32" fill="none"><circle cx="16" cy="16" r="12" stroke="#0043CE" stroke-width="2"/><path d="M12 16l3 3 5-6" stroke="#0043CE" stroke-width="2" stroke-linecap="round"/></svg>
    </div>
    <h3>Explain Any Program</h3>
    <p>Ask Bob to explain <code>CREACC.cbl</code> — it returns a structured breakdown: business purpose, data structures, DB2 operations, CICS calls, error handling, and a Mermaid flowchart. Two modes: architectural (Z Architect) or developer-level (Z Code).</p>
  </div>
  <div class="value-card">
    <div class="value-card-icon">
      <svg viewBox="0 0 32 32" fill="none"><path d="M6 4h20v24H6z" stroke="#0043CE" stroke-width="2"/><path d="M10 10h12M10 16h8M10 22h10" stroke="#0043CE" stroke-width="2" stroke-linecap="round"/></svg>
    </div>
    <h3>Plan Changes</h3>
    <p>Describe a new feature — Bob creates a complete implementation plan: which programs to modify, which copybooks are affected, what the COMMAREA changes look like, and what tests need updating. Saved to <code>bobz/implementation-plans/</code>.</p>
  </div>
  <div class="value-card">
    <div class="value-card-icon">
      <svg viewBox="0 0 32 32" fill="none"><path d="M8 8l16 16M8 24L24 8" stroke="#0043CE" stroke-width="2" stroke-linecap="round"/></svg>
    </div>
    <h3>Transform to Java</h3>
    <p>Bob can transform COBOL programs to Java following precise rules for FILLER fields, REDEFINES scenarios, DB2 SQL mapping, and CICS command translation — then validate the output with auto-generated JUnit tests.</p>
  </div>
</div>

## Bob's Modes for CBSA

Bob ships with three specialized modes for IBM Z work — all activated from the mode selector in the IDE:

<table class="compare-table">
<thead>
<tr>
  <th>Mode</th>
  <th>Best For</th>
  <th>Try It On CBSA</th>
</tr>
</thead>
<tbody>
<tr>
  <td><strong>Z Architect</strong></td>
  <td>Planning changes, impact analysis, technical documentation, architecture diagrams</td>
  <td>"What is the impact of changing the CREACC COMMAREA on all callers?"</td>
</tr>
<tr>
  <td><strong>Z Code</strong></td>
  <td>Explaining COBOL at developer level, writing/modifying programs, COBOL→Java transformation</td>
  <td>"Explain XFRFUN.cbl — how does the transfer between two accounts work?"</td>
</tr>
<tr>
  <td><strong>Ask z Assistant</strong></td>
  <td>IBM Z technical questions, IBM documentation search, z/OS Connect API design guidance</td>
  <td>"What are the differences between zosConnect-2.0 and zosConnect-3.0 Liberty features?"</td>
</tr>
</tbody>
</table>

## Skills Available for CBSA

Bob's skills are pre-configured globally for this workspace. Each can be invoked manually or activates automatically based on the user's request:

| Skill | What It Does |
|---|---|
| `explain` | Whole-program explanation with Mermaid diagram — architectural or developer focus |
| `implementation-planning` | Creates a spec-driven implementation plan from a description of the change |
| `impact-analysis` | Traces dependencies and produces a risk-rated impact report |
| `data-dictionary-management` | Generates `bobz/DD.json` to decode CBSA's 8-char naming conventions |
| `validate` | 4-phase COBOL→Java validation: data prep, resource mapping, JUnit generation, test execution |
| `cobol-transformation` | FILLER/REDEFINES/Lombok rules for CBSA COBOL→Java generation |
| `refactor-report-generation` | Identifies paragraphs in CREACC, XFRFUN etc. that are candidates for service extraction |

## Demo Scenarios

These are ready-to-run demos on the CBSA codebase:

### Demo 1 — Instant Code Understanding (5 min)

```
Mode: Z Code
Prompt: "Explain CREACC.cbl — focus on the Named Counter mechanism
         and why it needs ENQ/DEQ for account number generation"
```

Expected output: Purpose, data structures, Named Counter flow diagram, DB2 operations, error handling.

---

### Demo 2 — Impact Analysis (10 min)

```
Mode: Z Architect
Prompt: "I need to add a new field COMM_ACCOUNT_CATEGORY (PIC X(4))
         to the CREACC COMMAREA. What is the impact?"
```

Expected output: Impact report listing all 4 callers of CREACC, the z/OS Connect service that would need updating, the Spring Boot JSON model that would change, and a Mermaid propagation diagram.

---

### Demo 3 — Modernization Planning (15 min)

```
Mode: Z Architect
Prompt: "Create an implementation plan for migrating the creacc OAS2 API
         to the new OAS3 spec in zosconnect_artefacts/openapi3/"
```

Expected output: Step-by-step plan covering z/OS Connect Designer import, field mapping, Liberty server.xml update, Spring Boot binding changes, and test validation.

---

### Demo 4 — COBOL to Java (20 min)

```
Mode: Z Code
Prompt: "/transform CBSA/cobol/INQACC.cbl"
```

Expected output: Java class with `@Data` Lombok annotations, DB2 mapped to JDBC, CICS-specific code flagged for manual review, and a JUnit test template.

## Why This Matters for IBM Z Modernization

<div class="journey-strip">
  <div class="journey-step step-1">
    <div class="journey-step-label">Before Bob</div>
    <h4>Manual Analysis</h4>
    <p>Weeks to understand a COBOL program, manual copybook tracing, no automated impact analysis</p>
  </div>
  <div class="journey-arrow">→</div>
  <div class="journey-step step-2">
    <div class="journey-step-label">With Bob</div>
    <h4>AI-Assisted Z</h4>
    <p>Minutes to understand any program, automated impact reports, Java transformation with validation</p>
  </div>
  <div class="journey-arrow">→</div>
  <div class="journey-step step-3">
    <div class="journey-step-label">The Result</div>
    <h4>Faster Modernization</h4>
    <p>Teams move faster, knowledge is documented automatically, modernization backlog shrinks</p>
  </div>
</div>
