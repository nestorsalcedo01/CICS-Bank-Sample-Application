# CBSA Modernization Wiki Plan

## Top-Level Overview

Transform the CBSA Jekyll wiki into an **IBM Z Modernization Showcase Portal** that serves two
audiences simultaneously:

1. **Technical sellers / pre-sales** — A compelling "pitch" home page with technology badges,
   value propositions, architecture diagrams, and a modernization journey narrative that positions
   the full IBM Z ecosystem (CICS, DBB, z/OS Connect, Bob AI) as a coherent modernization story.

2. **Developers / architects** — Deep technical documentation showing both the legacy (OAS2 +
   zAppBuild/Groovy) and modern (OAS3 + DBB YAML) approaches side-by-side, so engineers can
   understand the migration path without losing the existing reference.

**Approach:** Bank-of-Z style — same wiki structure, but with a significantly richer Home page
acting as a pitch landing page, plus a new "Modernization Journey" section and upgraded technology
pages. All existing artefacts in the repo are preserved. New OAS3 spec files and a `dbb-app.yaml`
skeleton are added as illustrative artefacts alongside the originals.

**Scope:** Wiki content and layout only — no changes to COBOL source, build pipelines, or
z/OS Connect artefacts (except adding new illustrative files).

---

## Sub-Tasks

---

### Sub-Task 1 — Redesign the Home Page as a Pitch Landing Page

**Status:** `[ ] pending`

**Intent:**
Replace the current plain home page with a compelling visual landing page that communicates the
IBM Z modernization story at a glance. It should hook both a technical seller and a developer
within the first screen-full of content.

**Expected Outcomes:**
- Hero section with gradient IBM Blue banner, headline, and sub-headline
- "IBM Z Ecosystem" technology badge strip (CICS, DB2, z/OS Connect, DBB, Bob AI, Spring Boot)
- "What CBSA Demonstrates" value proposition cards (3 columns: Proven Platform, Modern APIs,
  AI-Assisted Development)
- "Modernization Journey" flow diagram (inline Mermaid: Legacy → Hybrid → Modern)
- Documentation section cards (existing 8 sections, visually enhanced)
- Footer with IBM branding

**Todo List:**
1. Redesign `docs/index.md` with the new hero, badge strip, value proposition cards,
   Mermaid journey diagram, and enhanced section cards
2. Update `docs/_layouts/default.html` to add CSS for: tech badges, value prop cards,
   3-column grid, journey timeline, IBM Blue gradient hero
3. Keep all existing section card links intact

**Relevant Context:**
- `docs/index.md` — current home page (hero + 8 doc cards)
- `docs/_layouts/default.html` — custom CSS and layout (754 lines)
- Bank-of-Z reference: hero banner + doc-cards pattern already in place

---

### Sub-Task 2 — Add "Modernization Journey" Section to the Wiki

**Status:** `[ ] pending`

**Intent:**
Create a new top-level wiki section that narrates the CBSA modernization story across three
technology dimensions: API layer (OAS2 → OAS3), build system (zAppBuild/Groovy → DBB YAML),
and developer tooling (manual → AI-assisted with Bob). This section is the "sales pitch in
documentation form" — technical enough for architects, readable enough for pre-sales.

**Expected Outcomes:**
- New section `docs/docs/modernization/` with 4 pages:
  - `index.md` — overview of the journey with a Mermaid architecture evolution diagram
  - `oas2-vs-oas3.md` — side-by-side comparison of OAS2 (existing) vs OAS3 approach,
    linking to actual artefacts in the repo, explaining why OAS3 matters
  - `zappbuild-vs-dbb-yaml.md` — side-by-side comparison of zAppBuild/Groovy (existing
    `application-conf/`) vs DBB YAML (`dbb-app.yaml`), with migration path guidance
  - `ai-assisted-development.md` — how Bob (AI) accelerates the development workflow on
    this codebase: explain, plan, transform, validate
- TOC generator updated and `_data/toc.yml` regenerated to include new section
- Sidebar position: **after "Build and Deploy"**, before "Program Reference"

**Relevant Context:**
- `zosconnect_artefacts/apis/creacc/api-docs/swagger.json` — existing OAS2 (Swagger 2.0) spec
- `CBSA/application-conf/*.properties` — existing zAppBuild Groovy configuration
- No `dbb-app.yaml` exists yet — a skeleton will be created in Sub-Task 3
- No OAS3 spec files exist yet — a sample will be created in Sub-Task 3

---

### Sub-Task 3 — Add Illustrative Modern Artefacts to the Repo

**Status:** `[ ] pending`

**Intent:**
Create the new-generation artefacts alongside the existing ones so the wiki's side-by-side
comparisons link to real files. These are illustrative/reference artefacts — they do not replace
the working OAS2/zAppBuild pipeline.

**Expected Outcomes:**
- `zosconnect_artefacts/openapi3/cbsa-banking-api.yaml` — a single consolidated OAS3 spec
  covering all 10 CICS operations derived from the 10 existing `swagger.json` files.
  Uses proper REST semantics: `GET /accounts/{id}`, `POST /accounts`,
  `DELETE /accounts/{id}`, `PUT /accounts/{id}`, `GET /customers/{id}`,
  `POST /customers`, `DELETE /customers/{id}`, `PUT /customers/{id}`,
  `GET /customers/{custId}/accounts`, `POST /payments`
- `CBSA/dbb-app.yaml` — DBB 3.x zBuilder YAML covering ALL languages:
  - BMS language task (must run before COBOL — build order preserved)
  - COBOL language task (compile + link-edit, with isCICS/isSQL/isDLI flags)
  - Assembler language task (for DFHNCOPT)
  - LinkEdit language task
  - zUnit test task
  - **z/OS Connect artifact deployment task** — copies SAR/AAR files to the
    z/OS Connect EE server `resources/` directories via USS file transfer
  - Dataset declarations (SYSLIB, CICSLOAD, LOAD, DBRM, ZUNIT)
- Both files include inline comments explaining the migration from the legacy approach

**Relevant Context:**
- `zosconnect_artefacts/apis/creacc/api-docs/swagger.json` — OAS2 reference for field names
  and data types to replicate in OAS3
- `CBSA/application-conf/Cobol.properties` — compile params to replicate in dbb-app.yaml
- `CBSA/application-conf/BMS.properties` — BMS params to replicate in dbb-app.yaml
- `CBSA/application-conf/application.properties` — build order and dataset patterns
- Bank-of-Z `dbb-app.yaml` — reference for the YAML structure (exists in that repo)

---

### Sub-Task 4 — Upgrade Existing zosconnect and build-and-deploy Wiki Pages

**Status:** `[ ] pending`

**Intent:**
Update the existing `docs/docs/zosconnect/` and `docs/docs/build-and-deploy/` sections to
acknowledge both generations of technology, link to the new artefacts from Sub-Task 3, and
reference the new Modernization Journey section. This keeps the existing documentation
accurate while integrating the modernization narrative.

**Expected Outcomes:**
- `docs/docs/zosconnect/index.md` — updated to mention OAS2 (current) and OAS3 (modern path),
  with a banner/callout linking to the modernization journey section
- `docs/docs/zosconnect/services.md` — updated to include a comparison table of OAS2 vs OAS3
  service definition approaches for the `creacc` operation as a concrete example
- `docs/docs/build-and-deploy/index.md` — updated to mention zAppBuild (current) and DBB YAML
  (modern path), with a link to modernization journey
- `docs/docs/build-and-deploy/zappbuild.md` — updated with a "Modern Alternative" callout
  section at the bottom pointing to `dbb-app.yaml`

**Relevant Context:**
- `docs/docs/zosconnect/index.md`, `services.md`, `server-config.md`
- `docs/docs/build-and-deploy/index.md`, `zappbuild.md`
- Modernization section created in Sub-Task 2

---

### Sub-Task 5 — Regenerate TOC and Validate Full Wiki

**Status:** `[ ] pending`

**Intent:**
Run the TOC generator to include the new Modernization section, verify all internal links
resolve, and ensure the Jekyll build succeeds cleanly with no broken references.

**Expected Outcomes:**
- `docs/_data/toc.yml` regenerated with "Modernization Journey" section in correct sidebar
  position (between "Build and Deploy" and "Program Reference")
- All `index.md` files in all sections have matching `.md` files for every link
- `docs/scripts/generate_toc_from_md.py` updated to include `"modernization"` in
  `SECTION_MAPPING` with the display name `"Modernization Journey"`
- Commit and push triggers GitHub Actions build with no errors

**Relevant Context:**
- `docs/scripts/generate_toc_from_md.py` — `SECTION_MAPPING` dict must be updated
- `docs/_data/toc.yml` — auto-generated, do not edit manually
- `.github/workflows/pages.yml` — GitHub Actions build that validates the Jekyll build

---

## Architecture Overview

```
CBSA Repository (after plan completion)
├── CBSA/
│   ├── application-conf/          ← EXISTING: zAppBuild .properties (unchanged)
│   └── dbb-app.yaml               ← NEW: DBB 3.x YAML skeleton (illustrative)
├── zosconnect_artefacts/
│   ├── apis/                      ← EXISTING: OAS2 swagger.json per API (unchanged)
│   └── openapi3/
│       └── cbsa-banking-api.yaml  ← NEW: Single consolidated OAS3 spec (illustrative)
└── docs/
    ├── index.md                   ← REDESIGNED: Pitch landing page
    ├── _layouts/default.html      ← UPDATED: New CSS for pitch components
    └── docs/
        ├── modernization/         ← NEW SECTION
        │   ├── index.md
        │   ├── oas2-vs-oas3.md
        │   ├── zappbuild-vs-dbb-yaml.md
        │   └── ai-assisted-development.md
        ├── zosconnect/            ← UPDATED: links to modernization section
        └── build-and-deploy/      ← UPDATED: links to modernization section
```

## Technology Narrative (the "pitch")

The wiki tells this story across three dimensions:

| Dimension | Legacy (Today) | Modern (Path Forward) |
|---|---|---|
| API Definition | OAS2 / Swagger 2.0 per-service `swagger.json` files | Single consolidated OAS3 YAML, designed first, implemented second |
| Build System | zAppBuild Groovy scripts + `.properties` files | DBB 3.x `dbb-app.yaml` — declarative YAML, no Groovy required |
| Developer Tooling | Manual COBOL editing, JCL submission | Bob AI — explain, plan, transform, validate from the IDE |

Both generations are **preserved and shown** — the message is "you can start here and move there,
IBM Z supports the full journey."
