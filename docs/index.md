---
layout: default
title: Home
---

<div class="hero-banner">
  <div style="width:100%;height:320px;background:linear-gradient(135deg,#0043CE 0%,#001D6C 100%);display:flex;align-items:flex-end;padding:0;">
  </div>
  <div class="hero-overlay">
    <h1>CICS Bank Sample Application</h1>
    <p>IBM internal reference documentation for CBSA — CICS, DB2, z/OS Connect EE, and Spring Boot banking demo.</p>
  </div>
</div>

Welcome to the CBSA documentation. Use this guide to understand the application architecture, navigate the COBOL program inventory, set up the environment, and follow the build and deploy pipelines.

## Documentation sections

<div class="doc-cards">

<a class="doc-card" href="docs/about-cbsa/">
<h3>About CBSA</h3>
<p>Purpose, capabilities, architecture overview, and key components of the CICS Bank Sample Application.</p>
</a>

<a class="doc-card" href="docs/architecture/">
<h3>Architecture</h3>
<p>System design, component interactions, data flow, DB2 schema, and z/OS Connect EE integration.</p>
</a>

<a class="doc-card" href="docs/installation-and-setup/">
<h3>Installation and Setup</h3>
<p>DB2 schema setup, CICS region configuration, z/OS Connect EE deployment, and Spring Boot UI setup.</p>
</a>

<a class="doc-card" href="docs/build-and-deploy/">
<h3>Build and Deploy</h3>
<p>zAppBuild pipeline, GitLab CI configuration, build properties, and deployment procedures.</p>
</a>

<a class="doc-card" href="docs/programs/">
<h3>Program Reference</h3>
<p>Complete inventory of COBOL programs, BMS maps, copybooks, and their interactions.</p>
</a>

<a class="doc-card" href="docs/testing/">
<h3>Testing</h3>
<p>zUnit framework, test case structure, playback files, and how to run and extend tests.</p>
</a>

<a class="doc-card" href="docs/zosconnect/">
<h3>z/OS Connect EE</h3>
<p>REST API services, Liberty server configuration, and service-to-program mappings.</p>
</a>

<a class="doc-card" href="docs/reference/">
<h3>Reference</h3>
<p>DB2 table schemas, copybook inventory, naming conventions, JCL jobs, and glossary.</p>
</a>

</div>

---

[GitHub Repository](https://github.com/nestorsalcedo01/CICS-Bank-Sample-Application)

---

*Last updated: {{ 'now' | date: "%B %d, %Y" }}*
