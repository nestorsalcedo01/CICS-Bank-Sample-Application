---
layout: default
title: About CBSA
---

# About CBSA

The CICS Bank Sample Application (CBSA) is an IBM internal demo application developed by the CICS TS CiP team. It provides a realistic banking workload for demonstrating CICS, DB2, z/OS Connect EE, and Spring Boot integration on IBM Z.

## Purpose

CBSA is designed to:

- Demonstrate CICS transaction processing patterns with DB2 integration
- Showcase z/OS Connect EE REST API exposure of CICS programs
- Provide a realistic sample for IBM Z development tooling (DBB, zAppBuild, IDz)
- Support zUnit testing demonstrations on z/OS
- Serve as a reference application for CICS TS CiP team materials

## Key Capabilities

| Capability | Technology |
|---|---|
| Core banking transactions | CICS COBOL + DB2 |
| REST API layer | z/OS Connect EE 2.0 |
| Browser-based UI | Spring Boot 2.5.4 + Thymeleaf |
| Batch data loading | CICS COBOL batch programs |
| Unit testing | IBM zUnit (BZUPLAY) |
| Build automation | IBM DBB + zAppBuild |
| CI/CD | GitLab CI |

## Supported Operations

- **Customer management:** Create, enquire, update, delete customers
- **Account management:** Create, enquire, update, delete accounts; list accounts by customer
- **Transactions:** Debit/credit, fund transfer between accounts
- **Payment interface:** Standalone payment processing via z/OS Connect EE

## Licensing

CBSA is for IBM internal use only. It is not licensed for external use. Open-source components consumed are listed in [`Notices.html`](../Notices.html).

## Topics in this section

- [Architecture Overview](../architecture/)
- [Program Reference](../programs/)
- [Installation and Setup](../installation-and-setup/)
