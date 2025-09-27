---
title: Medicaid Re-enrollment Orchestrator Architecture
---

# Medicaid Re-enrollment Orchestrator

This page summarizes the proposed state-level Orchestrator that uses FHIR-based interop to automatically verify community engagement or exemption status for Medicaid re-enrollment under HB1.

The design balances automation with strict privacy and statutory controls (Consent, DS4P/Part 2), and relies on a Trusted Source Registry to accept data from authoritative partners.

## Components and Responsibilities

- Front end / Portal
  - Collects re-enrollment inputs and minimal proof; starts orchestration.
- Medicaid Re-enrollment Orchestrator (core)
  - Coordinates flows, enforces rules, aggregates evidence, and produces decisions.
- Identity & Matching Service (MPI / PPRL)
  - Deterministic and probabilistic matching; PPRL for privacy-preserving linkage.
- Consent & Authorization Service
  - Manages Consent resources and access tokens; enforces DS4P/Part 2.
- Departmental FHIR Façades / Gateways (Labor, SSA, Corrections, Education, TANF/SNAP, VA, HIE, etc.)
  - Translate native data to FHIR; expose minimal authenticated APIs; log access.
- Trusted Sources & Cache / Data Lake
  - Periodic pulls or subscriptions; TTL/freshness and Provenance maintained.
- Decision Engine & Audit Trail
  - Rule evaluation; emits CoverageEligibilityResponse (or internal decision) with Provenance; logs AuditEvent.
- Notification & Appeals Workflow
  - Sends required notices; tracks Tasks for review/appeals; stores DocumentReference.

## High-Level Architecture

<div class="mermaid">
flowchart LR
  subgraph Portal[Front end / Portal]
    Q(Questionnaire/Uploads)
  end

  subgraph Orchestrator[Medicaid Re-enrollment Orchestrator]
    Rules(Decision Engine / Rules)
    Match(MPI / PPRL)
    ConsentSvc(Consent & AuthZ)
    Cache(Cache / Data Lake)
    Audit(Audit / Provenance)
  end

  Portal -->|Start re-enrollment| Orchestrator
  Orchestrator --> Match
  Orchestrator --> ConsentSvc
  Orchestrator --> Rules
  Orchestrator <--> Cache
  Orchestrator --> Audit

  subgraph Facades[Departmental FHIR Façades]
    Labor[Labor / Unemployment]
    SSA[SSA / SSDI]
    Corrections[Corrections]
    Education[Education]
    TANF[TANF / SNAP]
    VA[Veterans Affairs]
    HIE[HIE / Claims / Hospital]
  end

  Rules -->|FHIR queries| Labor
  Rules --> SSA
  Rules --> Corrections
  Rules --> Education
  Rules --> TANF
  Rules --> VA
  Rules --> HIE

  Facades -->|FHIR R4| Cache
  Cache --> Rules
</div>

## Orchestration Sequence (Typical Re-enrollment)

<div class="mermaid">
sequenceDiagram
  autonumber
  participant P as Portal
  participant O as Orchestrator
  participant M as Identity & Matching
  participant C as Consent/Authorization
  participant L as Labor Façade
  participant S as SSA Façade
  participant X as Corrections Façade
  participant D as Decision Engine

  P->>O: Submit re-enrollment (QuestionnaireResponse/Task)
  O->>C: Validate Consent (purpose: re-enrollment verification)
  O->>M: Resolve identity (deterministic + probabilistic/PPRL)
  O->>L: GET Observation?code=employment-hours&date=...
  O->>S: GET Condition?code=ssdi-entitlement
  O->>X: GET DocumentReference?type=corrections-release
  O->>D: Evaluate rules with Provenance & freshness
  D-->>O: Decision (meets hours OR exemption)
  O-->>P: Notify outcome (Communication/DocumentReference)
  O-->>O: Record AuditEvent + Provenance
</div>

## FHIR Resources Used (Highlights)

- Patient, Questionnaire/QuestionnaireResponse, Task
- Observation (employment-hours, income, county unemployment), Condition (pregnancy, disability), Encounter (hospitalization)
- CoverageEligibilityRequest/Response (optional for decision packaging), Coverage (enrollment context)
- Consent (purpose-limited), Provenance (source/agent/timestamp), AuditEvent (access logging)
- DocumentReference (uploaded or agency documents), Bundle (decision package), Endpoint (partner connectivity)
- Subscription/Bulk Data for periodic refreshes

## Mapping Law Checks to Data

- Worked ≥ 80 hours in lookback month
  - Labor façade → Observation employment-hours; accept if value ≥ 80 and source is trusted.
- Income threshold (monthly or 6-month avg)
  - Wage/IRS feeds → Observation monthly-income; compute average across period.
- Education enrollment (half-time)
  - Education façade → Condition student-status or Observation enrollment-status.
- Treatment program participation (exemption)
  - Behavioral health façade → DS4P-labeled data; enforce Consent/Part 2.
- Recent incarceration (≤ 3 months)
  - Corrections façade → incarceration period (Observation/DocumentReference).
- Short-term hardship (hospitalization)
  - HIE/hospital → Encounter with inpatient class overlapping lookback.

## Privacy, Trust, and Appeals

- Consent governs cross-agency queries unless statutory exception applies.
- DS4P/Part 2 labels applied; store minimal conclusions when possible to minimize redisclosure.
- Trusted Source Registry defines acceptable evidence (source, type, freshness, signature).
- Every access is logged via AuditEvent; decisions carry Provenance.
- Notices delivered via mail + one other channel; appeals tracked with Tasks.

## Phased Rollout (Roadmap)

- Phase 0: Governance & Trusted Source Registry; MOUs and policy.
- Phase 1: Pilot core façades (Labor, SSA, Corrections, claims) + identity & consent.
- Phase 2: Expand connectors (Education, TANF/SNAP, VA, HIE) + bulk ingest/cache.
- Phase 3: Scale & audit; publish acceptance rules; monitoring & appeals.
