---
layout: default
title: Glossary
---

# Glossary

<div class="callout callout-green">
<strong>35+ terms covering every abbreviation and concept in CBSA.</strong> Terms are sorted alphabetically A–Z. Use <kbd>Ctrl+F</kbd> / <kbd>⌘F</kbd> to jump to any term.
</div>

---

## A

<table class="compare-table">
<thead>
<tr>
  <th style="width:22%">Term</th>
  <th style="width:78%">Definition</th>
</tr>
</thead>
<tbody>
<tr>
  <td><strong>ABNDPROC</strong></td>
  <td>CICS program invoked on abend — writes abend information to the <code>ABNDINFO.cpy</code> record and handles cleanup. Called via <code>EXEC CICS HANDLE ABEND</code>.</td>
</tr>
<tr>
  <td><strong>ACCOUNT</strong></td>
  <td>Db2 table <code>IBMUSER.ACCOUNT</code> — the primary account store. Contains 12 columns including <code>ACCOUNT_NUMBER</code>, <code>ACCOUNT_TYPE</code>, <code>ACCOUNT_ACTUAL_BALANCE</code>. Layout defined in <code>ACCOUNT.cpy</code>.</td>
</tr>
</tbody>
</table>

---

## B

<table class="compare-table">
<thead>
<tr>
  <th style="width:22%">Term</th>
  <th style="width:78%">Definition</th>
</tr>
</thead>
<tbody>
<tr>
  <td><strong>BMS</strong></td>
  <td>Basic Mapping Support — CICS facility for defining and handling 3270 terminal screen maps. BMS source files (<code>.bms</code>) are compiled into load modules and generated copybooks (<code>BNK1*.cpy</code>).</td>
</tr>
<tr>
  <td><strong>BZUCFG</strong></td>
  <td>zUnit runner configuration file (XML) — pairs a test case program (e.g. <code>TBNKMENU</code>) with its playback recording file. One BZUCFG per test program.</td>
</tr>
</tbody>
</table>

---

## C

<table class="compare-table">
<thead>
<tr>
  <th style="width:22%">Term</th>
  <th style="width:78%">Definition</th>
</tr>
</thead>
<tbody>
<tr>
  <td><strong>CBSA</strong></td>
  <td>CICS Bank Sample Application — this project. A fully functional banking application used to demonstrate z/OS, CICS, Db2, and z/OS Connect EE integration.</td>
</tr>
<tr>
  <td><strong>CBSAWLP</strong></td>
  <td>CICS Liberty JVM server name hosting the Spring Boot Customer Services UI on port <code>19080</code>. Defined as a CICS JVM server resource. The WAR context root is <code>/customerservices-1.0</code>.</td>
</tr>
<tr>
  <td><strong>CICS</strong></td>
  <td>Customer Information Control System — IBM transaction-processing middleware that hosts COBOL programs, Liberty JVM servers, and VSAM file access on z/OS.</td>
</tr>
<tr>
  <td><strong>CICS Bundle</strong></td>
  <td>Deployment artifact produced by the <code>cics-bundle-maven-plugin</code> — a ZIP-like archive containing the WAR file plus a CICS manifest (<code>META-INF/cics.xml</code>). Deployed to a USS directory and installed as a CICS bundle resource.</td>
</tr>
<tr>
  <td><strong>COMMAREA</strong></td>
  <td>Communication area — fixed-length data block passed between CICS programs via <code>EXEC CICS LINK PROGRAM(...) COMMAREA(...)</code>. In CBSA, each service program has one or more COMMAREA copybooks defining the request/response layout.</td>
</tr>
<tr>
  <td><strong>COMMAREA variant</strong></td>
  <td>Some CBSA programs have two COMMAREA copybooks — one for direct CICS LINK calls (e.g. <code>INQACC.cpy</code>) and one with a <code>Z</code> suffix for z/OS Connect EE JSON mapping (e.g. <code>INQACCZ.cpy</code>). The Z variant may have adjusted field lengths or padding to align with JSON serialisation constraints.</td>
</tr>
<tr>
  <td><strong>connectionInfo</strong></td>
  <td>Java class <code>ConnectionInfo.java</code> in the Spring Boot application — holds the z/OS Connect EE host and port, defaulting to <code>localhost:30701</code>. The host and port can be overridden at startup with the <code>--address</code> and <code>--port</code> arguments.</td>
</tr>
<tr>
  <td><strong>Copybook</strong></td>
  <td>COBOL include file (<code>.cpy</code>) defining shared data layouts. COPYed into programs using the <code>COPY</code> statement in the DATA DIVISION or LINKAGE SECTION. All 51 CBSA copybooks are in <code>CBSA/copylib/</code>.</td>
</tr>
</tbody>
</table>

---

## D

<table class="compare-table">
<thead>
<tr>
  <th style="width:22%">Term</th>
  <th style="width:78%">Definition</th>
</tr>
</thead>
<tbody>
<tr>
  <td><strong>DBB</strong></td>
  <td>IBM Dependency Based Build — build framework for z/OS source. CBSA uses DBB (via zAppBuild) to compile COBOL, BMS, and Assembler on z/OS.</td>
</tr>
<tr>
  <td><strong>DBCG</strong></td>
  <td>Db2 for z/OS subsystem name used by CBSA. All CBSA SQL plans are bound against <code>DBCG</code>. See also <strong>PCBSA</strong>.</td>
</tr>
<tr>
  <td><strong>DSECT</strong></td>
  <td>Dummy section — a generated COBOL structure produced by BMS map compilation. Used as a copybook in screen handler programs to reference 3270 field offsets and attributes by name. Do not edit <code>BNK1*.cpy</code> files — they are DSECTs regenerated on every build.</td>
</tr>
</tbody>
</table>

---

## E

<table class="compare-table">
<thead>
<tr>
  <th style="width:22%">Term</th>
  <th style="width:78%">Definition</th>
</tr>
</thead>
<tbody>
<tr>
  <td><strong>ENQ / DEQ</strong></td>
  <td><code>EXEC CICS ENQ</code> / <code>EXEC CICS DEQ</code> — CICS resource enqueue and dequeue. Used by <code>CREACC</code> and <code>CRECUST</code> to serialise the Named Counter read + record create as a single atomic unit, preventing duplicate account or customer numbers under concurrent load.</td>
</tr>
</tbody>
</table>

---

## H

<table class="compare-table">
<thead>
<tr>
  <th style="width:22%">Term</th>
  <th style="width:78%">Definition</th>
</tr>
</thead>
<tbody>
<tr>
  <td><strong>HBNKACCT</strong></td>
  <td>CICS Named Counter name for account number generation — used by <code>CREACC</code>. The counter is incremented inside an ENQ/DEQ guard to ensure each new account number is unique. Initial value, increment, and maximum are set in <code>CBSA/asm/DFHNCOPT.assemble</code>.</td>
</tr>
<tr>
  <td><strong>HBNKCUST</strong></td>
  <td>CICS Named Counter name for customer number generation — used by <code>CRECUST</code>. Same ENQ/DEQ serialisation pattern as <code>HBNKACCT</code>.</td>
</tr>
<tr>
  <td><strong>HLQ</strong></td>
  <td>High-Level Qualifier — the prefix for z/OS dataset names (e.g., <code>GITLAB.CBSA</code> or <code>IBMUSER.CBSA</code>). Used in JCL and build scripts to locate CBSA datasets.</td>
</tr>
</tbody>
</table>

---

## I

<table class="compare-table">
<thead>
<tr>
  <th style="width:22%">Term</th>
  <th style="width:78%">Definition</th>
</tr>
</thead>
<tbody>
<tr>
  <td><strong>IPIC</strong></td>
  <td>IP-Interconnectivity — the z/OS Connect EE → CICS connection protocol. CBSA uses IPIC on port <code>30709</code> for the z/OS Connect EE server to invoke CICS programs via <code>EXEC CICS LINK</code>.</td>
</tr>
</tbody>
</table>

---

## N

<table class="compare-table">
<thead>
<tr>
  <th style="width:22%">Term</th>
  <th style="width:78%">Definition</th>
</tr>
</thead>
<tbody>
<tr>
  <td><strong>Named Counter</strong></td>
  <td>CICS shared counter used for sequential ID generation. CBSA uses two: <code>HBNKACCT</code> (account numbers, via <code>CREACC</code>) and <code>HBNKCUST</code> (customer numbers, via <code>CRECUST</code>). Counter options are defined in <code>CBSA/asm/DFHNCOPT.assemble</code>.</td>
</tr>
</tbody>
</table>

---

## P

<table class="compare-table">
<thead>
<tr>
  <th style="width:22%">Term</th>
  <th style="width:78%">Definition</th>
</tr>
</thead>
<tbody>
<tr>
  <td><strong>PCBSA</strong></td>
  <td>Db2 package collection ID used for CBSA BIND statements. The <code>P</code> prefix denotes package/plan. All CBSA static SQL is bound under collection <code>PCBSA</code> against subsystem <code>DBCG</code>.</td>
</tr>
<tr>
  <td><strong>PROCTRAN</strong></td>
  <td>Processing Transaction — CBSA's audit log Db2 table (<code>IBMUSER.PROCTRAN</code>). Every state-changing operation (create, update, delete, transfer) writes a row to PROCTRAN. Layout defined in <code>PROCTRAN.cpy</code>.</td>
</tr>
</tbody>
</table>

---

## S

<table class="compare-table">
<thead>
<tr>
  <th style="width:22%">Term</th>
  <th style="width:78%">Definition</th>
</tr>
</thead>
<tbody>
<tr>
  <td><strong>SAR / AAR</strong></td>
  <td>Service Archive / API Archive — deployable artifacts for z/OS Connect EE. A SAR bundles a CICS service definition; an AAR bundles the REST API definition (OAS2 swagger). CBSA has one SAR + AAR pair per CICS program exposed as a REST API.</td>
</tr>
<tr>
  <td><strong>Sort Code</strong></td>
  <td>6-digit bank identifier — CBSA uses <code>987654</code>. Defined as a constant in <code>SORTCODE.cpy</code> and COPYed into every program that needs the bank's sort code.</td>
</tr>
<tr>
  <td><strong>Spring Boot UI</strong></td>
  <td>The Customer Services web interface — a Spring Boot WAR deployed to Liberty JVM server <code>CBSAWLP</code> on port <code>19080</code>. Source is in <code>Z-OS-Connect-EE-Customer-Services-Interface/</code>.</td>
</tr>
<tr>
  <td><strong>SSI</strong></td>
  <td>System Status Information — an 8-character field embedded in a z/OS load module that is typically used to store build metadata such as an abbreviated Git commit hash.</td>
</tr>
</tbody>
</table>

---

## T

<table class="compare-table">
<thead>
<tr>
  <th style="width:22%">Term</th>
  <th style="width:78%">Definition</th>
</tr>
</thead>
<tbody>
<tr>
  <td><strong>Thymeleaf</strong></td>
  <td>Server-side HTML template engine used by the Spring Boot UI. Templates are in <code>src/main/resources/templates/</code>. Each screen (e.g. account enquiry, create customer) has a corresponding <code>.html</code> template that is rendered by <code>WebController</code>.</td>
</tr>
</tbody>
</table>

---

## U

<table class="compare-table">
<thead>
<tr>
  <th style="width:22%">Term</th>
  <th style="width:78%">Definition</th>
</tr>
</thead>
<tbody>
<tr>
  <td><strong>UoW</strong></td>
  <td>Unit of Work — the DB2/CICS transaction scope for a commit. <code>XFRFUN</code> uses <code>EXEC CICS SYNCPOINT</code> to commit both the debit and credit sides of a transfer atomically. If either side fails, a <code>SYNCPOINT ROLLBACK</code> is issued.</td>
</tr>
</tbody>
</table>

---

## V

<table class="compare-table">
<thead>
<tr>
  <th style="width:22%">Term</th>
  <th style="width:78%">Definition</th>
</tr>
</thead>
<tbody>
<tr>
  <td><strong>VSAM KSDS</strong></td>
  <td>Virtual Storage Access Method Key-Sequenced Data Set — used by CBSA for Customer records. Customers are stored in VSAM (not Db2). The record layout is defined in <code>CUSTOMER.cpy</code>. Access is via <code>EXEC CICS FILE READ/WRITE/DELETE</code>.</td>
</tr>
</tbody>
</table>

---

## W

<table class="compare-table">
<thead>
<tr>
  <th style="width:22%">Term</th>
  <th style="width:78%">Definition</th>
</tr>
</thead>
<tbody>
<tr>
  <td><strong>WebClient</strong></td>
  <td>Spring WebFlux reactive HTTP client used by the Spring Boot UI to call z/OS Connect EE REST endpoints. Replaces the deprecated <code>RestTemplate</code>. A new <code>WebClient</code> instance is created per request inside <code>WebController</code>.</td>
</tr>
</tbody>
</table>

---

## Z

<table class="compare-table">
<thead>
<tr>
  <th style="width:22%">Term</th>
  <th style="width:78%">Definition</th>
</tr>
</thead>
<tbody>
<tr>
  <td><strong>z/OS Connect EE</strong></td>
  <td>z/OS Connect Enterprise Edition 2.0 — REST API gateway running in a Liberty JVM server inside the CICS region. Accepts JSON REST requests from Spring Boot (on ports <code>30701</code> HTTP / <code>30702</code> HTTPS) and invokes CICS programs via IPIC COMMAREA LINK on port <code>30709</code>. Config file: <code>zoseeserver/server.xml</code>.</td>
</tr>
<tr>
  <td><strong>zAppBuild</strong></td>
  <td>IBM open-source Groovy build framework built on top of DBB. Provides language scripts for COBOL, BMS, Assembler, and more. CBSA uses zAppBuild for its CI/CD pipeline builds.</td>
</tr>
<tr>
  <td><strong>zosConnect-2.0</strong></td>
  <td>Liberty server feature (<code>zosconnect:zosConnect-2.0</code>) that enables z/OS Connect EE 2.0 REST gateway functionality. Declared in <code>zoseeserver/server.xml</code> under the <code>&lt;featureManager&gt;</code> element.</td>
</tr>
<tr>
  <td><strong>zosConnect-3.0</strong></td>
  <td>Liberty server feature for next-generation z/OS Connect with OpenAPI 3 (OAS3) support. A forward-compatible upgrade path from <code>zosConnect-2.0</code>.</td>
</tr>
<tr>
  <td><strong>zUnit</strong></td>
  <td>IBM Z Automated Unit Testing Framework — COBOL/PL/I unit test runner. CBSA test cases are in <code>testcase/</code> and paired with playback recordings via BZUCFG files. Run via <code>RUNZUNIT.jcl</code>.</td>
</tr>
</tbody>
</table>

<div class="callout">
<strong>Missing a term?</strong> Open a pull request adding the new row to the appropriate letter section in <code>docs/docs/reference/glossary.md</code>.
</div>
