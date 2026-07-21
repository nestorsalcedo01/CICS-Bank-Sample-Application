---
layout: default
title: Home
---

<div class="hero-banner">
  <div class="hero-banner-bg"></div>
  <div class="hero-edition-badge">IBM Z Modernization Showcase</div>
  <div class="hero-overlay">
    <h1>CICS Bank Sample Application</h1>
    <p>A living reference for IBM Z modernization — CICS, DB2, z/OS Connect, DBB, and AI-assisted development working together on a real banking workload.</p>
    <a href="docs/modernization/" class="hero-cta">Explore the Modernization Journey →</a>
  </div>
</div>

<div class="tech-strip">
  <span class="tech-badge tech-badge-blue">CICS TS</span>
  <span class="tech-badge tech-badge-red">DB2 for z/OS</span>
  <span class="tech-badge tech-badge-teal">z/OS Connect 3.0</span>
  <span class="tech-badge tech-badge-gray">DBB 3.x zBuilder</span>
  <span class="tech-badge tech-badge-purple">IBM Bob AI</span>
  <span class="tech-badge tech-badge-cyan">Spring Boot on Liberty</span>
  <span class="tech-badge tech-badge-green">GitLab CI/CD</span>
</div>

<h2 class="section-heading">Why CBSA Matters</h2>

<div class="value-cards">
  <div class="value-card">
    <div class="value-card-icon">
      <svg viewBox="0 0 32 32" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M16 2L2 8v8c0 8.8 6 17 14 19 8-2 14-10.2 14-19V8L16 2z" stroke="#0043CE" stroke-width="2" fill="none"/></svg>
    </div>
    <h3>Proven Enterprise Platform</h3>
    <p>Demonstrates real CICS transaction patterns with DB2 integration — the same technologies powering the world's most critical banking, insurance, and government systems. 39 COBOL programs, 51 copybooks, 10 REST APIs.</p>
  </div>
  <div class="value-card">
    <div class="value-card-icon">
      <svg viewBox="0 0 32 32" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M4 6h24v4H4zm0 8h16v4H4zm0 8h20v4H4z" stroke="#0043CE" stroke-width="2" fill="none"/></svg>
    </div>
    <h3>Modern API Layer</h3>
    <p>Shows both generations of z/OS Connect — OAS2 (production-ready today) and OAS3 (the modern path forward). REST APIs expose CICS programs without changing a single line of COBOL, preserving decades of business logic.</p>
  </div>
  <div class="value-card">
    <div class="value-card-icon">
      <svg viewBox="0 0 32 32" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M8 8h16v16H8z" stroke="#0043CE" stroke-width="2" fill="none"/><path d="M12 16l3 3 5-6" stroke="#0043CE" stroke-width="2" stroke-linecap="round"/></svg>
    </div>
    <h3>AI-Assisted Development</h3>
    <p>IBM Bob AI explains, plans, transforms, and validates COBOL programs — turning weeks of analysis into hours. The same codebase you see here is the one Bob reasons about in real demos.</p>
  </div>
</div>

<h2 class="section-heading">The Modernization Journey</h2>

<p>CBSA is designed to show that IBM Z modernization is not a replacement — it is an evolution. Each technology generation is preserved and documented alongside its successor.</p>

<div class="journey-strip">
  <div class="journey-step step-1">
    <div class="journey-step-label">Where You Are</div>
    <h4>Traditional z/OS</h4>
    <p>COBOL + CICS + DB2, zAppBuild/Groovy pipeline, OAS2 APIs per service, manual development workflows</p>
  </div>
  <div class="journey-arrow">→</div>
  <div class="journey-step step-2">
    <div class="journey-step-label">Hybrid Modernization</div>
    <h4>API-Enabled Platform</h4>
    <p>z/OS Connect bridges legacy to cloud, DBB YAML replaces Groovy scripts, unified OAS3 API spec, CI/CD automation</p>
  </div>
  <div class="journey-arrow">→</div>
  <div class="journey-step step-3">
    <div class="journey-step-label">Modern Platform</div>
    <h4>AI-Accelerated Z</h4>
    <p>Bob AI explains and transforms code, OAS3-first design, declarative builds, containers for tooling — IBM Z as a first-class modern platform</p>
  </div>
</div>

<div class="callout callout-green">
  <strong>New:</strong> The <a href="docs/modernization/">Modernization Journey</a> section documents all three stages with side-by-side comparisons of OAS2 vs OAS3, zAppBuild vs DBB YAML, and manual vs AI-assisted development — with real artefacts in this repository for each.
</div>

<h2 class="section-heading">Documentation</h2>

<div class="doc-cards">

<a class="doc-card" href="docs/about-cbsa/">
<div class="doc-card-tag">Overview</div>
<h3>About CBSA</h3>
<p>Purpose, capabilities, architecture overview, and key components.</p>
</a>

<a class="doc-card" href="docs/architecture/">
<div class="doc-card-tag">Architecture</div>
<h3>Architecture</h3>
<p>System design, component interactions, data flow, and DB2 schema.</p>
</a>

<a class="doc-card" href="docs/modernization/">
<div class="doc-card-tag">Modernization</div>
<h3>Modernization Journey</h3>
<p>OAS2 vs OAS3, zAppBuild vs DBB YAML, AI-assisted development.</p>
</a>

<a class="doc-card" href="docs/installation-and-setup/">
<div class="doc-card-tag">Setup</div>
<h3>Installation and Setup</h3>
<p>DB2 schema, CICS region, z/OS Connect, and Spring Boot UI setup.</p>
</a>

<a class="doc-card" href="docs/build-and-deploy/">
<div class="doc-card-tag">Build</div>
<h3>Build and Deploy</h3>
<p>zAppBuild pipeline, GitLab CI, build properties, and deployment.</p>
</a>

<a class="doc-card" href="docs/programs/">
<div class="doc-card-tag">Reference</div>
<h3>Program Reference</h3>
<p>Complete COBOL program inventory — all 39 programs documented.</p>
</a>

<a class="doc-card" href="docs/testing/">
<div class="doc-card-tag">Quality</div>
<h3>Testing</h3>
<p>zUnit framework, test structure, playback files, and test commands.</p>
</a>

<a class="doc-card" href="docs/zosconnect/">
<div class="doc-card-tag">APIs</div>
<h3>z/OS Connect EE</h3>
<p>REST services, Liberty server configuration, OAS2 and OAS3 specs.</p>
</a>

<a class="doc-card" href="docs/reference/">
<div class="doc-card-tag">Reference</div>
<h3>Reference</h3>
<p>Copybook inventory, BMS maps, naming conventions, and glossary.</p>
</a>

<a class="doc-card" href="architecture-review/">
<div class="doc-card-tag">Architecture Review</div>
<h3>Architecture Review</h3>
<p>ATAM · DORA · Well-Architected analysis — hallazgos, riesgos y hoja de ruta de modernización.</p>
</a>

</div>

---

<p style="font-size:0.85rem;color:#6f6f6f;margin-top:2rem;">
  <a href="{{ site.repository_url }}" target="_blank">GitHub Repository</a> &nbsp;·&nbsp;
  IBM Internal Use Only &nbsp;·&nbsp;
  Last updated: {{ 'now' | date: "%B %d, %Y" }}
</p>
