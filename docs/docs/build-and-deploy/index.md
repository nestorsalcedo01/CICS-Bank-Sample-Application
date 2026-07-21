---
layout: default
title: Build and Deploy
---

# Build and Deploy

CBSA documents **both generations** of the IBM Z build toolchain — the production-ready zAppBuild/Groovy pipeline and the modern DBB YAML approach.

<div class="callout callout-green">
<strong>Modernization available:</strong> A <a href="../modernization/zappbuild-vs-dbb-yaml.html">DBB YAML build definition</a> (<code>CBSA/dbb-app.yaml</code>) is included alongside the existing zAppBuild configuration — showing the side-by-side migration path.
</div>

## Two Build Generations

<table class="compare-table">
<thead>
<tr>
  <th style="width:30%">Aspect</th>
  <th class="col-legacy">zAppBuild / Groovy (Current)</th>
  <th class="col-modern">DBB YAML / zBuilder (Modern)</th>
</tr>
</thead>
<tbody>
<tr>
  <td><strong>Configuration</strong></td>
  <td class="col-legacy">15 <code>.properties</code> files in <code>application-conf/</code></td>
  <td class="col-modern">One <code>CBSA/dbb-app.yaml</code></td>
</tr>
<tr>
  <td><strong>Language scripts</strong></td>
  <td class="col-legacy">Groovy scripts per language</td>
  <td class="col-modern">Declarative YAML tasks — no Groovy</td>
</tr>
<tr>
  <td><strong>DBB version</strong></td>
  <td class="col-legacy">DBB 1.x / 2.x</td>
  <td class="col-modern">DBB 3.0.4+</td>
</tr>
<tr>
  <td><strong>z/OS Connect deploy</strong></td>
  <td class="col-legacy">Manual SAR/AAR copy</td>
  <td class="col-modern">Built-in deploy task in <code>dbb-app.yaml</code></td>
</tr>
</tbody>
</table>

## Topics in this section

- [zAppBuild Pipeline](zappbuild.html)
- [GitLab CI](gitlab-ci.html)
- [Build Properties Reference](build-properties.html)
- [Spring Boot WAR Build](spring-boot-build.html)

---

**→ See also:** [zAppBuild vs DBB YAML — Full Comparison](../modernization/zappbuild-vs-dbb-yaml.html)
