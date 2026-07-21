---
layout: default
title: "Architecture Review — CBSA z/OS"
---

# CBSA — Revisión de Arquitectura z/OS
## Aplicando la Guía `revision_arquitectura_zosv2.md`

**Fecha:** 2025-07  
**Aplicación:** CICS Bank Sample Application (CBSA)  
**Rama:** `architecture_zos`  
**Metodología:** ATAM · DORA · Well-Architected for z/OS  
**Revisor:** Análisis automatizado sobre artefactos del repositorio

---

## Índice

1. [Contextualización y Drivers de Negocio](#1-contextualización-y-drivers-de-negocio)
2. [Mapa de Arquitectura Actual](#2-mapa-de-arquitectura-actual)
3. [Árbol de Atributos de Calidad](#3-árbol-de-atributos-de-calidad)
4. [Análisis ATAM — Enfoques y Riesgos](#4-análisis-atam--enfoques-y-riesgos)
5. [Pilar 1 — Excelencia Operativa (DORA)](#5-pilar-1--excelencia-operativa-dora)
6. [Pilar 2 — Seguridad (Zero Trust)](#6-pilar-2--seguridad-zero-trust)
7. [Pilar 3 — Fiabilidad y Resiliencia](#7-pilar-3--fiabilidad-y-resiliencia)
8. [Pilar 4 — Eficiencia de Rendimiento y Costos (FinOps)](#8-pilar-4--eficiencia-de-rendimiento-y-costos-finops)
9. [Checklist de Revisión — Estado Actual](#9-checklist-de-revisión--estado-actual)
10. [Hallazgos Críticos y Plan de Acción](#10-hallazgos-críticos-y-plan-de-acción)
11. [Hoja de Ruta de Modernización](#11-hoja-de-ruta-de-modernización)

---

## 1. Contextualización y Drivers de Negocio

### 1.1 Descripción de la Aplicación

CBSA es una aplicación bancaria de referencia que ejecuta íntegramente en un único **z/OS LPAR**. Proporciona operaciones CRUD para cuentas y clientes bancarios, transacciones financieras (transferencias, débitos/créditos) y una interfaz web moderna basada en Spring Boot.

### 1.2 Inventario de Componentes

| Componente | Tecnología | Cantidad | Ubicación |
|---|---|---|---|
| Programas COBOL | CICS + DB2/VSAM | 39 programas | `CBSA/cobol/` |
| Mapas BMS (3270) | CICS BMS | 10 mapas | `CBSA/bms/` |
| Copybooks | COBOL Include | 51 copybooks | `CBSA/copylib/` |
| Tabla DB2 | DB2 for z/OS (DBCG) | 4 tablas (ACCOUNT, PROCTRAN, CONTROL, CONSENT) | Subsistema DBCG |
| VSAM KSDS | EXEC CICS FILE | 1 archivo (Customer) | CICS region |
| Servidores Liberty | JVM Server CICS | 2 servidores | `CBSAWLP` (Spring Boot) + z/OS Connect EE |
| APIs REST (OAS2) | z/OS Connect EE 2.0 | 10 APIs | `zosconnect_artefacts/apis/` |
| UI Web | Spring Boot 2.5.4 / Thymeleaf | 1 WAR | `Z-OS-Connect-EE-Customer-Services-Interface/` |
| Pipeline CI/CD | GitLab CI + zAppBuild | 1 pipeline | `.gitlab-ci.yml` |
| Programa Assembler | HLASM (Named Counter) | 1 (`DFHNCOPT`) | `CBSA/asm/` |
| Tests unitarios | zUnit | 1 caso (`TBNKMENU`) | `CBSA/testcase/` |

### 1.3 Drivers de Negocio Identificados

| Driver | Descripción | Impacto en Arquitectura |
|---|---|---|
| **Disponibilidad transaccional** | Operaciones bancarias en tiempo real (CICS) | Alta disponibilidad CICS + UoW con SYNCPOINT |
| **Procesamiento Batch** | Carga masiva de datos, cálculo de intereses | ACCOFFL, PROOFFL ejecutados periódicamente |
| **Integración moderna** | Exposición de servicios COBOL como REST APIs | z/OS Connect EE 2.0 → OAS2 → Spring Boot |
| **Generación secuencial de IDs** | Números de cuenta/cliente únicos | CICS Named Counter Server (HBNKACCT, HBNKCUST) |
| **Scoring crediticio** | Evaluación durante apertura de cuenta | CRDTAGY1–5 (simuladores, no productivos) |
| **Trazabilidad financiera** | Registro de todas las operaciones | IBMUSER.PROCTRAN (tabla de auditoría) |

---

## 2. Mapa de Arquitectura Actual

```mermaid
flowchart TD
    Browser["🌐 Browser\n(Usuario Final)"]

    subgraph LPAR ["z/OS LPAR — Single System of Record"]
        subgraph CICSRegion ["CICS Region (CBSA)"]
            subgraph LibertyUI ["Liberty JVM Server: CBSAWLP\n:19080"]
                SpringBoot["☕ Spring Boot 2.5.4\nCustomer Services UI\nThymeleaf + WebClient"]
            end

            subgraph LibertyZC ["Liberty JVM Server: z/OS Connect EE\n:30701 / :30702"]
                ZOSConnect["🔌 z/OS Connect EE 2.0\n10 APIs OAS2\nzosConnect-2.0 feature"]
            end

            subgraph ScreenHandlers ["BMS Screen Handlers (9)"]
                BMS["BNKMENU · BNK1CAC\nBNK1CCS · BNK1CCA\nBNK1CRA · BNK1DAC\nBNK1DCS · BNK1TFN · BNK1UAC"]
            end

            subgraph ServicePrograms ["Service Programs (18)"]
                Account["Account Domain\nCREACC · INQACC · INQACCCU\nUPDACC · DELACC"]
                Customer["Customer Domain\nCRECUST · INQCUST\nUPDCUST · DELCUS"]
                Payment["Payment Domain\nXFRFUN · DBCRFUN · DPAYAPI"]
                Utils["Utilities\nGETSCODE · GETCOMPY\nABNDPROC · CONSENT\nCRDTAGY1-5"]
            end
        end

        subgraph DataLayer ["Data Layer"]
            DB2["🗄️ DB2 DBCG\nIBMUSER.ACCOUNT\nIBMUSER.PROCTRAN\nIBMUSER.CONTROL\nIBMUSER.CONSENT"]
            VSAM["📁 VSAM KSDS\nCustomer File\n(EXEC CICS FILE)"]
            NCS["🔢 Named Counter Server\nHBNKACCT · HBNKCUST"]
        end
    end

    Terminal["📺 3270 Terminal\n(Usuario Interno)"]

    Browser -->|"HTTP :19080"| SpringBoot
    SpringBoot -->|"WebClient localhost:30701\nREST/JSON"| ZOSConnect
    ZOSConnect -->|"IPIC localhost:30709\nCOMMAREA"| ServicePrograms
    Terminal -->|"CICS Txn BMNU/BCAC/etc."| ScreenHandlers
    ScreenHandlers -->|"EXEC CICS LINK"| ServicePrograms
    ServicePrograms -->|"EXEC SQL"| DB2
    Customer -->|"EXEC CICS FILE"| VSAM
    Account -->|"EXEC CICS ENQ/DEQ\n+ COUNTER"| NCS

    classDef jvm fill:#d0e2ff,stroke:#0043ce,color:#001d6c
    classDef cobol fill:#e8daff,stroke:#6929c4,color:#1c0f30
    classDef data fill:#defbe6,stroke:#198038,color:#0e3818
    classDef external fill:#f4f4f4,stroke:#697077,color:#161616
    classDef risk fill:#fff1f1,stroke:#da1e28,color:#a2191f

    class SpringBoot,ZOSConnect jvm
    class BMS,Account,Customer,Payment,Utils cobol
    class DB2,VSAM,NCS data
    class Browser,Terminal external
```

### 2.1 Flujo de Datos Principal

```mermaid
sequenceDiagram
    autonumber
    participant B as Browser
    participant SB as Spring Boot<br/>CBSAWLP :19080
    participant ZC as z/OS Connect EE<br/>:30701
    participant CICS as CICS Program<br/>(ej. CREACC)
    participant DB2 as DB2 DBCG
    participant NCS as Named Counter<br/>HBNKACCT
    participant PROC as IBMUSER.PROCTRAN

    B->>SB: POST /createacc (formulario)
    SB->>ZC: POST http://localhost:30701/creacc/insert
    ZC->>CICS: EXEC CICS LINK PROGRAM(CREACC)
    CICS->>NCS: EXEC CICS ENQ + GET COUNTER(HBNKACCT)
    CICS->>CICS: EXEC CICS LINK PROGRAM(CRDTAGY1..5)
    CICS->>DB2: EXEC SQL INSERT INTO IBMUSER.ACCOUNT
    CICS->>PROC: EXEC SQL INSERT INTO IBMUSER.PROCTRAN
    CICS->>NCS: EXEC CICS DEQ
    CICS-->>ZC: COMMAREA response
    ZC-->>SB: HTTP 200 + JSON
    SB-->>B: Thymeleaf rendered response
```

---

## 3. Árbol de Atributos de Calidad

Basado en el análisis del código fuente y los artefactos del repositorio:

```mermaid
mindmap
  root((CBSA<br/>Calidad))
    Disponibilidad
      Target 99.999%
      CICS SYNCPOINT / ROLLBACK
      DB2 Deadlock Retry hasta 6 intentos XFRFUN
      ABNDPROC centralizado para abend handling
      Named Counter ENQ/DEQ serialization
    Seguridad
      RACF DFHDB2.AUTHTYPE.HBANK y DBCG
      Basic Auth ibmuser/SYS1 RIESGO DEMO
      requireAuth=false RIESGO CRÍTICO
      CORS allowedOrigins=* RIESGO
      Sin AT-TLS configurado RIESGO
    Rendimiento
      CICS quasi-reentrant CONCURRENCY
      DB2 Cursor Stability isolation CS
      Named Counter serialization cuello de botella
      No hay circuit breaker en WebClient
    Mantenibilidad
      1 test unitario TBNKMENU cobertura baja
      39 COBOL + 51 copybooks bien nombrados
      CI/CD GitLab zAppBuild pipeline existente
      DBB YAML alternativa documentada
    Trazabilidad
      IBMUSER.PROCTRAN como audit log
      ABNDPROC escribe a ABNDFILE KSDS
      SLF4J log.info en Spring Boot nivel bajo
      Sin SMF records configurados
```

---

## 4. Análisis ATAM — Enfoques y Riesgos

### 4.1 Decisiones Arquitectónicas Identificadas

| ID | Decisión | Justificación | Alternativa | Impacto |
|---|---|---|---|---|
| AD-01 | Datos de cliente en VSAM KSDS (no DB2) | Rendimiento CICS FILE, modelo histórico | Migrar a DB2 para SQL join capabilities | Rendimiento vs. consultabilidad |
| AD-02 | Named Counter Server para IDs secuenciales | Garantía de unicidad bajo carga concurrente | UUID / Sequence DB2 | Serialización vs. simplicidad |
| AD-03 | z/OS Connect EE como gateway REST | Exposición de COBOL sin cambios de código | API Management externo | Latencia interna vs. integración |
| AD-04 | Spring Boot dentro de CICS Liberty JVM | Todo en z/OS, sin salida de datos | Contenedor externo en OCP | Seguridad vs. flexibilidad de escala |
| AD-05 | DB2 Isolation Level CS (Cursor Stability) | Balance entre concurrencia y consistencia | RR (Repeatable Read) o UR | Rendimiento vs. consistencia |
| AD-06 | 5 agencias de crédito simuladas (CRDTAGY1-5) | Prueba de concepto, no producción | Integración real con bureau de crédito | Demo vs. producción |
| AD-07 | OAS2 Swagger 2.0 (10 specs separadas) | Generado automáticamente por z/OS Connect EE 2.0 | OAS3 unificado (`cbsa-banking-api.yaml`) | Mantenibilidad vs. esfuerzo de migración |

### 4.2 Puntos de Sensibilidad Identificados

| ID | Punto de Sensibilidad | Componente(s) Afectado(s) | Impacto si cambia |
|---|---|---|---|
| SP-01 | Named Counter (HBNKACCT/HBNKCUST) | CREACC, CRECUST | Cambiar el nombre o valor inicial rompe toda la secuencia de IDs |
| SP-02 | COMMAREA layout (ej. CSACCCRE) | CREACC ↔ z/OS Connect ↔ Spring Boot | Cambio de longitud afecta 3 capas simultáneamente |
| SP-03 | DB2 subsystem DBCG + collection PCBSA | Todos los programas SQL | Cambio de subsistema requiere rebind de todos los DBRM |
| SP-04 | Puerto IPIC 30709 | z/OS Connect EE ↔ CICS | Si el IPCONN falla, todos los 10 APIs quedan inoperativos |
| SP-05 | XFRFUN UoW boundary (SYNCPOINT) | XFRFUN, DBCRFUN | Error en SYNCPOINT puede dejar el UoW en estado indeterminado |
| SP-06 | JVM Server CBSAWLP hardcoded en pom.xml | Spring Boot WAR deployment | Cambiar el nombre del JVM server requiere recompilar el CICS bundle |

### 4.3 Tradeoffs Arquitectónicos

| Tradeoff | Opción A (Actual) | Opción B (Alternativa) | Impacto en Atributos |
|---|---|---|---|
| **Dato de cliente** | VSAM KSDS — alta velocidad CICS, sin SQL JOIN | DB2 tabla CUSTOMER | Perf+ / SQL+. Histórico: cambiarlo requiere migración de datos |
| **Autenticación API** | Basic Auth (ibmuser/SYS1) — simple demo | RACF/SAF + OAuth2 / API Keys | Seguridad++ / Complejidad+ |
| **Resiliencia WebClient** | `catch(WebClientRequestException)` — sin retry ni circuit breaker | Resilience4j / Retry pattern | Resiliencia++ / Overhead+ |
| **Trazabilidad** | `log.info()` sin estructura — difícil correlación | JSON estructurado (logstash) → ELK/Splunk | Observabilidad++ / Configuración+ |
| **Build pipeline** | zAppBuild + Groovy (activo) vs. DBB YAML (incluido como referencia) | Migrar a DBB 3.x YAML | Mantenibilidad++ / Migración de esfuerzo |

---

## 5. Pilar 1 — Excelencia Operativa (DORA)

### 5.1 Frecuencia de Despliegue

**Estado actual:**

```mermaid
flowchart LR
    Dev["👨‍💻 Developer\nIDz / Bob IDE"]
    Git["📦 Git\n(GitLab)"]
    CI["🔄 GitLab CI Pipeline\n.gitlab-ci.yml"]
    zAppBuild["⚙️ zAppBuild\n(Groovy + DBB)"]
    COBOL["📋 Load Modules\nCICSLOAD / LOAD"]
    CICS["🏦 CICS Region\nProgram Install"]
    Pages["📚 GitHub Pages\nJekyll Wiki\n(docs/ branch master)"]

    Dev -->|"git push"| Git
    Git -->|"trigger"| CI
    CI -->|"fullBuild"| zAppBuild
    zAppBuild -->|"HLQGITLAB.CBSA.*"| COBOL
    COBOL -->|"CICS NEWCOPY/PHASEIN"| CICS
    Git -->|"push to master\n(docs/)"| Pages

    classDef active fill:#defbe6,stroke:#198038,color:#0e3818
    classDef risk fill:#fff1f1,stroke:#da1e28,color:#a2191f
    classDef neutral fill:#f4f4f4,stroke:#697077,color:#161616

    class Dev,Git,CI,zAppBuild,COBOL,CICS active
    class Pages active
```

| Indicador DORA | Estado CBSA | Evidencia en repo | Brecha |
|---|---|---|---|
| **Deployment Frequency** | ✅ Pipeline CI/CD existe | `.gitlab-ci.yml` con etapas Preparation/Import/Build-Test | Sin evidencia de frecuencia real de deploy |
| **Lead Time for Changes** | ⚠️ Parcial | Build auto en push, pero deploy a CICS es manual (CICS NEWCOPY) | Automatizar instalación CICS post-build |
| **Change Failure Rate** | ⚠️ Bajo control | `cobol_storeSSI=true` (git hash en SSI del módulo) | Sin smoke tests automáticos post-deploy |
| **MTTR** | ⚠️ Manual | `ABNDPROC` captura abends, `jclInstall/RESTCICS.jcl` para restart | Sin alertas automáticas, depende de logs JES |

### 5.2 Observabilidad — Estado Actual vs Objetivo

| Capa | Estado Actual | Hallazgo | Recomendación |
|---|---|---|---|
| **COBOL / CICS** | `DISPLAY` statements en DBCRFUN, INQACC, XFRFUN | Mensajes de deadlock enviados a SYSOUT (no structured) | Implementar SMF Type 119 records o CICS monitoring facility |
| **Spring Boot** | `log.info(responseBody)`, `log.info(e.toString())` en WebController | Sin MDC / Correlation ID, nivel INFO siempre | Añadir JSON structured logging + correlation ID por request |
| **z/OS Connect EE** | Liberty server logs estándar | Sin WLP access log personalizado | Configurar `<accessLogging logFormat>` en server.xml |
| **DB2** | DISPLAY en DEADLOCK paths | Registro pasivo, sin alarma | SMF 101/102 records + Tivoli/WLM alerting |
| **Pipeline CI/CD** | Logs GitLab estándar | Sin métricas de build time/failure rate | Integrar con herramienta de métricas DORA |

### 5.3 Pruebas

| Tipo de Prueba | Estado | Evidencia | Brecha |
|---|---|---|---|
| **zUnit (unitarias)** | ⚠️ Mínimo | `CBSA/testcase/TBNKMENU.cbl` — 1 solo test para BNKMENU | Cobertura < 3% (1/39 programas). Crear tests para CREACC, XFRFUN, DBCRFUN |
| **Build con tests** | ✅ Configurado | `runzTests=true` en `application.properties` | Tests insuficientes |
| **Load/stress tests** | ❌ No existe | No hay JCL ni scripts de carga | Crear scripts de prueba de carga CICS |
| **Integration tests** | ❌ No existe | No hay tests de integración Spring Boot | Añadir tests con WebClient mock |

---

## 6. Pilar 2 — Seguridad (Zero Trust)

### 6.1 Matriz de Riesgos de Seguridad

```mermaid
%%{init: {'quadrantChart': {'chartWidth': 400, 'chartHeight': 400}}}%%
quadrantChart
    title Riesgos de Seguridad — Probabilidad vs. Impacto
    x-axis Baja Probabilidad --> Alta Probabilidad
    y-axis Bajo Impacto --> Alto Impacto
    quadrant-1 CRÍTICO
    quadrant-2 ALTO
    quadrant-3 BAJO
    quadrant-4 MEDIO
    requireAuth=false: [0.9, 0.95]
    Credenciales demo en server.xml: [0.85, 0.9]
    CORS allowedOrigins=*: [0.7, 0.6]
    Sin AT-TLS en tránsito: [0.6, 0.8]
    Keystore password=Liberty: [0.5, 0.7]
    Un solo usuario RACF: [0.4, 0.75]
    Sin escaneo SAST: [0.5, 0.5]
```

### 6.2 Análisis Detallado por Control

#### Identidad y Acceso

| Control | Estado | Evidencia en repo | Riesgo | Acción Requerida |
|---|---|---|---|---|
| **RACF mínimo privilegio** | ⚠️ Parcial | `RACF001.jcl`: `RDEFINE FACILITY DFHDB2.AUTHTYPE.HBANK`, permisos a CICSUSER, IBMUSER, JCOLLET, OGRADYJ | IDs personales hardcoded en JCL | Usar grupos RACF en vez de IDs individuales |
| **Autenticación z/OS Connect** | ❌ Crítico | `requireAuth="false"` en `server.xml:70` | Sin autenticación — cualquiera puede invocar los 10 APIs | Cambiar a `requireAuth="true"` + integrar RACF/SAF |
| **Credenciales básicas** | ❌ Crítico | `ibmuser / SYS1` hardcoded en `server.xml` | Credenciales de demo en producción | Usar RACF security domain, eliminar basicRegistry |
| **Keystore password** | ❌ Alto | `password="Liberty"` en `server.xml` | Password default, conocido públicamente | Cambiar con `securityUtility encode` |
| **Autorización Spring Boot** | ⚠️ Ninguna | No hay Spring Security en pom.xml | UI sin autenticación | Añadir Spring Security o delegar a z/OS AT-TLS |

#### Cifrado y Transporte

| Control | Estado | Evidencia | Riesgo | Acción Requerida |
|---|---|---|---|---|
| **AT-TLS (tránsito)** | ❌ No configurado | No hay policy de AT-TLS en server.xml o PAGENT | Tráfico en claro en la red z/OS | Configurar AT-TLS policy para puertos 30701/19080 |
| **HTTPS z/OS Connect** | ⚠️ Puerto disponible | Puerto 30702 configurado pero `requireSecure="false"` | HTTP permitido aunque HTTPS exista | `requireSecure="true"` en producción |
| **Pervasive Encryption** | ❌ No evaluable | No hay DFSMS/ICSF config en repo | Datasets sensibles pueden no estar cifrados | Evaluar cifrado de datasets con DFSMS Encryption |
| **Comunicación interna** | ⚠️ Loopback | Spring Boot → z/OS Connect vía `localhost:30701` | Loopback no sale de LPAR pero sin TLS | Considerar AT-TLS incluso en loopback |

#### Segregación de Entornos

| Control | Estado | Evidencia | Recomendación |
|---|---|---|---|
| **Dev vs Prod datasets** | ✅ Configurado | HLQ `GITLAB.CBSA` en `.gitlab-ci.yml` | Asegurar HLQ diferente para cada entorno |
| **Código sin datos reales** | ✅ Correcto | Solo BANKDATA genera datos sintéticos | Mantener prohibición de datos reales en repo |
| **JVM servers separados** | ✅ Correcto | CBSAWLP separado de z/OS Connect EE | Correcto — cada servidor con su propia security domain |

#### Análisis Estático (SAST)

| Control | Estado | Evidencia | Recomendación |
|---|---|---|---|
| **Code Review en build** | ✅ Configurado | `cobol_compileErrorPrefixParms=ADATA,EX(ADX(ELAXMGUX))` + `codeReview.properties` | Habilitado en zAppBuild |
| **Secretos en repositorio** | ⚠️ Riesgo | `password="SYS1"` y `password="Liberty"` en `server.xml` (en repo) | Mover a variables de entorno o IBM Vault |
| **Análisis DAST** | ❌ No existe | Sin evidencia de pruebas de seguridad dinámica | Añadir OWASP ZAP o equivalente para APIs REST |

---

## 7. Pilar 3 — Fiabilidad y Resiliencia

### 7.1 Análisis de Puntos Únicos de Fallo (SPOF)

```mermaid
flowchart TD
    subgraph SPOFs ["⚠️ Single Points of Failure Identificados"]
        SPOF1["SPOF-1: Puerto IPIC 30709\nSi falla la conexión IPIC,\nlos 10 APIs quedan inoperativos"]
        SPOF2["SPOF-2: Named Counter Server\nHBNKACCT serializa CREACC\n— cuello de botella bajo alta carga"]
        SPOF3["SPOF-3: CRDTAGY1-5\nLlamadas síncronas secuenciales\n— 5 LINK calls en CREACC"]
        SPOF4["SPOF-4: Un JVM Server por función\nSin load balancing entre JVM servers"]
    end

    subgraph Resilience ["✅ Mecanismos de Resiliencia Existentes"]
        R1["XFRFUN: DB2 Deadlock Retry\nhasta 6 intentos\n(DB2-DEADLOCK-RETRY < 6)"]
        R2["CREACC/CRECUST: ENQ/DEQ\nSerialización de Named Counter\ncorrectamente implementada"]
        R3["XFRFUN: SYNCPOINT ROLLBACK\nEN TODOS los caminos de error\n(confirmado en 10+ ubicaciones)"]
        R4["ABNDPROC: Abend Handler\nCaptura abends y escribe a ABNDFILE\nUsado por todos los screen handlers"]
    end

    classDef spof fill:#fff1f1,stroke:#da1e28,color:#a2191f
    classDef resilience fill:#defbe6,stroke:#198038,color:#0e3818

    class SPOF1,SPOF2,SPOF3,SPOF4 spof
    class R1,R2,R3,R4 resilience
```

### 7.2 Análisis de Resiliencia por Componente

#### XFRFUN — Transferencia de Fondos (Componente Crítico)

```mermaid
stateDiagram-v2
    [*] --> StartTransfer: EXEC CICS LINK XFRFUN
    StartTransfer --> DebitCheck: Verificar saldo fuente
    DebitCheck --> DebitOK: Saldo suficiente
    DebitCheck --> Rollback: Saldo insuficiente
    DebitOK --> CreditAccount: DBCRFUN débito
    CreditAccount --> DeadlockRetry: DB2 Deadlock (SQLCODE -911)
    DeadlockRetry --> CreditAccount: Retry < 6
    DeadlockRetry --> Rollback: Retry >= 6
    CreditAccount --> WritePROCTRAN: INSERT IBMUSER.PROCTRAN
    WritePROCTRAN --> Syncpoint: EXEC CICS SYNCPOINT
    Syncpoint --> [*]: Commit OK
    Rollback --> [*]: SYNCPOINT ROLLBACK

    note right of DeadlockRetry
        DB2-DEADLOCK-RETRY counter
        hasta 6 intentos automáticos
        Código XFRFUN.cbl línea 1292-1295
    end note
```

| Aspecto | Estado | Detalle | Recomendación |
|---|---|---|---|
| **UoW / SYNCPOINT** | ✅ Correcto | `EXEC CICS SYNCPOINT ROLLBACK` en todos los caminos de error — confirmado en 10+ ubicaciones en XFRFUN | Sin cambios requeridos |
| **DB2 Deadlock Retry** | ✅ Implementado | `DB2-DEADLOCK-RETRY` counter con máximo 6 intentos | Considerar incrementar a 10 bajo alta carga |
| **Overdraft check** | ✅ Correcto | Verificación de saldo antes de débito | Sin cambios requeridos |
| **PROCTRAN audit** | ✅ Correcto | Escribe a IBMUSER.PROCTRAN en cada operación | Añadir index si las consultas por fecha son frecuentes |

#### Spring Boot WebClient — Resiliencia de la Capa HTTP

| Aspecto | Estado | Evidencia | Riesgo | Recomendación |
|---|---|---|---|---|
| **Circuit Breaker** | ❌ No existe | Solo `catch(WebClientRequestException)` en 10 endpoints de WebController | Si z/OS Connect EE está caído, cada request espera el timeout | Añadir Resilience4j CircuitBreaker |
| **Timeout configurado** | ❌ No explícito | No hay `WebClient.builder().responseTimeout()` en el código | Requests pueden colgar indefinidamente | Configurar `responseTimeout(Duration.ofSeconds(30))` |
| **Retry logic** | ❌ No existe | No hay `retry()` en la cadena reactiva | Fallos transitorios no se recuperan | Añadir `.retry(3)` con backoff exponencial |
| **Fallback UI** | ⚠️ Básico | Muestra `e.toString()` al usuario en caso de error | Exposición de detalles técnicos al usuario | Implementar páginas de error amigables |

### 7.3 Awareness de Parallel Sysplex

| Aspecto | Estado | Evidencia | Recomendación |
|---|---|---|---|
| **Sysplex-aware** | ❌ No evaluable | No hay configuración XCF/CF en el repo | Verificar configuración a nivel de CICS région (SYSPLEXNAME, CFSFILE) |
| **Coupling Facility** | ⚠️ Parcial | ABNDPROC menciona "centralised CF (KSDS) datastore" — usa VSAM como CF alternativo | Evaluar migración a CICS CF data tables para estado compartido |
| **Named Counter Server** | ✅ Correcto | CICS Named Counter Server es Sysplex-aware por diseño | Asegurar que el NCS esté configurado en el Sysplex |
| **DB2 Data Sharing** | ⚠️ No configurado | Un solo subsistema DBCG | Considerar DB2 Data Sharing para HA en producción |

---

## 8. Pilar 4 — Eficiencia de Rendimiento y Costos (FinOps)

### 8.1 Consumo de Recursos (MIPS/I/O)

| Componente | Patrón de Consumo | Identificado en | Optimización Posible |
|---|---|---|---|
| **CREACC** | Alto — ENQ + 5 LINK a CRDTAGY + DB2 INSERT | CREACC.cbl | Paralelizar llamadas a CRDTAGY o reducir a 1 si no es producción |
| **XFRFUN** | Alto — 2 UPDATE + 2 INSERT PROCTRAN + SYNCPOINT | XFRFUN.cbl | DB2 batching de INSERTs en PROCTRAN |
| **INQACCCU** | Medio-alto — DB2 cursor sin límite explícito | INQACCCU.cbl | Paginación + FETCH FIRST N ROWS ONLY |
| **ACCOFFL** | Alto Batch — cursor + UPDATE en toda la tabla | ACCOFFL.cbl | Procesamiento paralelo con DFSORT o MQ trigger |
| **Spring Boot JVM** | Medio — 2 JVM servers en misma región | CBSAWLP + z/OS Connect | Evaluar consolidación si los recursos son limitados |
| **Logs DISPLAY** | Bajo impacto actual | DBCRFUN, INQACC, XFRFUN | Compilar con TEST(NOSEP) en producción elimina overhead debug |

### 8.2 Eficiencia de APIs REST (z/OS Connect EE)

| Métrica | OAS2 Actual | OAS3 (Disponible) | Beneficio Modernización |
|---|---|---|---|
| **Número de specs** | 10 archivos swagger.json separados | 1 `cbsa-banking-api.yaml` | Reducción de 90% en artefactos de API |
| **Semántica REST** | Paths planos (`/insert`, `/remove/{accno}`) | Recursos RESTful (`/accounts/{id}`) | Interoperabilidad mejorada |
| **Error handling** | Solo HTTP 200 definido | 400, 404, 500 documentados | Mejor gestión de errores en clientes |
| **Seguridad en spec** | `securityDefinitions` básico | `components/securitySchemes` OAuth2/OIDC | Preparado para Zero Trust |
| **z/OS Connect versión** | 2.0 (`zosConnect-2.0`) | 3.0 (`zosConnect-3.0`) | Design-first, mejor tooling |

### 8.3 Identificación de Procesos Batch Obsoletos

| Programa | Propósito | Estado Evaluado | Recomendación |
|---|---|---|---|
| `BANKDATA` | Generador de datos sintéticos | Solo para setup inicial | Candidato a archivar post-setup |
| `ACCLOAD` | Carga masiva de cuentas | Load/reload escenarios | Mantener para DR/refresh |
| `PROLOAD` | Carga inicial PROCTRAN | Demo seeding | Candidato a archivar — solo para demos |
| `ACCOFFL` | Intereses + estados de cuenta | Proceso periódico activo | Mantener — optimizar con paginación |
| `PROOFFL` | Archivado PROCTRAN | Mantenimiento activo | Mantener — añadir scheduling automático |
| `CONSTTST` | Diagnóstico de constantes | Solo validación de entorno | Integrar en smoke tests post-deploy |

---

## 9. Checklist de Revisión — Estado Actual

### Operaciones y Cultura

| # | Pregunta | Estado | Evidencia | Acción |
|---|---|---|---|---|
| 1 | ¿Existe pipeline CI/CD para despliegue de módulos z/OS? | ✅ **SÍ** | `.gitlab-ci.yml` con etapas Preparation/Import/Build-Test usando zAppBuild | Automatizar también el install CICS post-build |
| 2 | ¿Los logs de aplicación están estructurados para análisis externo? | ❌ **NO** | `log.info()` sin estructura en Spring Boot; `DISPLAY` en COBOL | Implementar JSON logging + SMF records |
| 3 | ¿Se realizan pruebas de carga/estrés en LPAR equivalente? | ❌ **NO** | Solo 1 test unitario TBNKMENU; sin evidencia de load testing | Crear suite de pruebas de carga |

### Seguridad

| # | Pregunta | Estado | Evidencia | Acción |
|---|---|---|---|---|
| 4 | ¿Se aplica principio de menor privilegio en RACF? | ⚠️ **PARCIAL** | `RACF001.jcl` define permisos correctamente, pero usa IDs personales hardcoded | Migrar a grupos RACF |
| 5 | ¿Están protegidos los datasets sensibles mediante cifrado? | ❌ **NO EVALUABLE** | Sin configuración DFSMS/Pervasive Encryption en repo | Auditoría de datasets sensibles |
| 6 | ¿Se escanea el código antes del despliegue? | ⚠️ **PARCIAL** | `codeReview.properties` configurado en zAppBuild | Añadir SAST para Java + análisis de secretos |

### Fiabilidad y Rendimiento

| # | Pregunta | Estado | Evidencia | Acción |
|---|---|---|---|---|
| 7 | ¿La aplicación es Sysplex-aware? | ⚠️ **PARCIAL** | Named Counter Server es Sysplex-aware; DB2 sin Data Sharing | Configurar CICS región para Sysplex |
| 8 | ¿Existen mecanismos de Circuit Breaker si un servicio externo falla? | ❌ **NO** | Solo `catch(WebClientRequestException)` sin retry/CB en WebController | Implementar Resilience4j |
| 9 | ¿El modelo de acceso a datos minimiza contención en DB2? | ⚠️ **PARCIAL** | Isolation CS correcto; XFRFUN con deadlock retry; pero sin paginación en cursores | Añadir FETCH FIRST N ROWS en INQACCCU |

### FinOps y Valor

| # | Pregunta | Estado | Evidencia | Acción |
|---|---|---|---|---|
| 10 | ¿Se monitorea el costo por transacción? | ❌ **NO** | Sin integración WLM/SMF para medición de MIPS por transacción | Configurar CICS monitoring + WLM reporting |
| 11 | ¿Se han identificado procesos Batch obsoletos para refactorización? | ✅ **SÍ** | BANKDATA, PROLOAD identificados como candidatos | Ver sección 8.3 |

---

## 10. Hallazgos Críticos y Plan de Acción

### Semáforo de Riesgos

```mermaid
%%{init: {"theme": "base"}}%%
flowchart LR
    subgraph Critical ["🔴 CRÍTICO — Acción Inmediata"]
        C1["SEC-01\nrequireAuth=false\nen server.xml"]
        C2["SEC-02\nCredenciales demo\nibmuser/SYS1\nen producción"]
        C3["SEC-03\nPassword Liberty\nen keystore"]
    end
    subgraph High ["🟠 ALTO — Próximo Sprint"]
        H1["SEC-04\nCORS allowedOrigins=*"]
        H2["SEC-05\nSin AT-TLS\nen tránsito interno"]
        H3["RES-01\nSin Circuit Breaker\nen WebClient"]
        H4["OPS-01\nSolo 1 zUnit test\ncobertura < 3%"]
    end
    subgraph Medium ["🟡 MEDIO — Próxima Iteración"]
        M1["OBS-01\nLogs no estructurados\nsin correlación ID"]
        M2["RES-02\nSin timeout en WebClient"]
        M3["PERF-01\nCursores sin paginación\nen INQACCCU"]
        M4["MOD-01\nOAS2 → OAS3\nMigración pendiente"]
    end
    subgraph Low ["🟢 BAJO — Backlog"]
        L1["OPS-02\nMTTR manual\n— automatizar CICS install"]
        L2["FIN-01\nSin métricas\nde costo/transacción"]
        L3["PERF-02\nDBRKFUN DISPLAY\nen deadlock paths"]
    end

    classDef critical fill:#fff1f1,stroke:#da1e28,color:#a2191f
    classDef high fill:#fff8e1,stroke:#f1c21b,color:#3c2a00
    classDef medium fill:#d0e2ff,stroke:#0043ce,color:#001d6c
    classDef low fill:#defbe6,stroke:#198038,color:#0e3818

    class C1,C2,C3 critical
    class H1,H2,H3,H4 high
    class M1,M2,M3,M4 medium
    class L1,L2,L3 low
```

### Plan de Acción Priorizado

#### 🔴 Crítico — Ejecutar antes de cualquier despliegue en producción

| ID | Acción | Archivo(s) | Estimado |
|---|---|---|---|
| SEC-01 | Cambiar `requireAuth="false"` → `"true"` en `zoseeserver/server.xml` | `zoseeserver/server.xml:70` | 1 hora |
| SEC-02 | Eliminar `basicRegistry` con ibmuser/SYS1 — integrar RACF SAF security domain | `zoseeserver/server.xml:12-19` | 1 día |
| SEC-03 | Encode keystore password con `securityUtility encode` | `zoseeserver/server.xml:10` | 30 min |

#### 🟠 Alto — Próximo sprint (2 semanas)

| ID | Acción | Archivo(s) | Estimado |
|---|---|---|---|
| SEC-04 | Restringir CORS `allowedOrigins` al hostname de Spring Boot | `zoseeserver/server.xml:32-39` | 30 min |
| SEC-05 | Configurar AT-TLS policy para puertos 30701 y 19080 | PAGENT config (z/OS) | 2 días |
| RES-01 | Añadir Resilience4j CircuitBreaker + Retry en WebController | `WebController.java` | 3 días |
| OPS-01 | Crear tests zUnit para CREACC, XFRFUN, DBCRFUN | `CBSA/testcase/` | 1 semana |

#### 🟡 Medio — Próxima iteración (4 semanas)

| ID | Acción | Archivo(s) | Estimado |
|---|---|---|---|
| OBS-01 | JSON structured logging en Spring Boot + MDC Correlation ID | `WebController.java`, `pom.xml` | 2 días |
| RES-02 | Configurar `responseTimeout` en WebClient | `WebController.java` | 2 horas |
| PERF-01 | Añadir `FETCH FIRST 100 ROWS ONLY` en cursor de INQACCCU | `CBSA/cobol/INQACCCU.cbl` | 4 horas |
| MOD-01 | Migrar z/OS Connect EE a OAS3 usando `cbsa-banking-api.yaml` | `zosconnect_artefacts/openapi3/` | 1 semana |

---

## 11. Hoja de Ruta de Modernización

```mermaid
gantt
    title Hoja de Ruta de Modernización CBSA
    dateFormat  YYYY-MM-DD
    section 🔴 Seguridad Crítica
    SEC-01 requireAuth=true           :crit, s1, 2025-07-28, 1d
    SEC-02 RACF SAF domain            :crit, s2, 2025-07-29, 3d
    SEC-03 Keystore encode            :crit, s3, 2025-07-28, 1d
    section 🟠 Resiliencia y Cobertura
    SEC-04 CORS restrict              :s4, 2025-08-04, 1d
    SEC-05 AT-TLS config              :s5, 2025-08-04, 5d
    RES-01 Circuit Breaker WebClient  :r1, 2025-08-04, 5d
    OPS-01 zUnit test coverage        :o1, 2025-08-04, 7d
    section 🟡 Observabilidad
    OBS-01 Structured logging         :ob1, 2025-08-18, 3d
    RES-02 WebClient timeout          :r2, 2025-08-18, 1d
    PERF-01 INQACCCU pagination       :p1, 2025-08-18, 1d
    section 🔵 Modernización API
    MOD-01 OAS3 migration Bob-assisted :m1, 2025-08-25, 7d
    MOD-02 DBB YAML pipeline active    :m2, 2025-09-01, 5d
    section 🟢 FinOps y Observabilidad Avanzada
    FIN-01 WLM MIPS per transaction    :f1, 2025-09-08, 5d
    OBS-02 SMF structured records      :ob2, 2025-09-08, 5d
```

### Resumen Ejecutivo

| Dimensión | Estado Actual | Estado Objetivo | Tiempo Estimado |
|---|---|---|---|
| **Seguridad** | 🔴 3 vulnerabilidades críticas en config demo | 🟢 Zero Trust con RACF SAF + AT-TLS | 2 semanas |
| **Observabilidad** | 🟠 Logs ad-hoc, sin correlación | 🟢 Structured logging + SMF + ELK/Splunk | 4 semanas |
| **Resiliencia** | 🟡 Buena en COBOL, débil en Spring Boot | 🟢 Circuit Breaker + Timeout + Retry | 3 semanas |
| **Cobertura de tests** | 🔴 < 3% (1/39 programas) | 🟡 > 30% para programas críticos | 6 semanas |
| **API Modernization** | 🟡 OAS2 funcional, OAS3 disponible | 🟢 OAS3 en producción con z/OS Connect 3.0 | 8 semanas |
| **DevOps Pipeline** | 🟡 CI/CD activo, deploy manual | 🟢 CI/CD completo con CICS PHASEIN automático | 4 semanas |
| **FinOps** | 🔴 Sin métricas de costo | 🟡 WLM reporting activo | 6 semanas |

---

> **Nota:** Este análisis fue generado a partir de los artefactos del repositorio CBSA en la rama `architecture_zos`.  
> Los hallazgos de seguridad (credenciales demo) son **esperados** en una aplicación de muestra — deben corregirse antes de cualquier uso en entorno no-demo.  
> Para ejecutar cada paso de modernización con IBM Bob, ver [`docs/docs/modernization/`](../docs/modernization/index.md).
