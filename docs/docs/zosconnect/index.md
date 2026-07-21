---
layout: default
title: z/OS Connect EE
---

# z/OS Connect EE

z/OS Connect exposes CICS programs as REST APIs. CBSA includes artefacts for **both generations** of z/OS Connect — showing the migration path from OAS2 to OAS3.

<div class="callout callout-green">
<strong>Modernization available:</strong> CBSA ships with a unified <a href="../modernization/oas2-vs-oas3.html">OAS3 specification</a> alongside the original OAS2 definitions — demonstrating the migration path without removing the working baseline.
</div>

## Two Generations, One CICS Backend

<table class="compare-table">
<thead>
<tr>
  <th style="width:30%">Aspect</th>
  <th class="col-legacy">z/OS Connect EE 2.0 (Current)</th>
  <th class="col-modern">z/OS Connect 3.0 (Modern)</th>
</tr>
</thead>
<tbody>
<tr>
  <td><strong>Liberty feature</strong></td>
  <td class="col-legacy"><code>zosConnect-2.0</code></td>
  <td class="col-modern"><code>zosConnect-3.0</code></td>
</tr>
<tr>
  <td><strong>API spec</strong></td>
  <td class="col-legacy">Swagger 2.0 — 10 separate <code>swagger.json</code> files</td>
  <td class="col-modern">OpenAPI 3.0 — one unified <code>cbsa-banking-api.yaml</code></td>
</tr>
<tr>
  <td><strong>Artefacts</strong></td>
  <td class="col-legacy"><code>sarfiles/*.sar</code> + <code>aarfiles/*.aar</code></td>
  <td class="col-modern">Imported via z/OS Connect Designer from OAS3 YAML</td>
</tr>
<tr>
  <td><strong>CICS programs</strong></td>
  <td class="col-legacy">Unchanged — same COBOL, same COMMAREA</td>
  <td class="col-modern">Unchanged — same COBOL, same COMMAREA</td>
</tr>
</tbody>
</table>

## Topics in this section

- [Services Reference](services.html)
- [Liberty Server Configuration](server-config.html)

---

**→ See also:** [OAS2 vs OAS3 — Full Comparison](../modernization/oas2-vs-oas3.html)
