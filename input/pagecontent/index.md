---
title: Medicaid Work Requirements IG
---

# FHIR Implementation Guide for Medicaid Work Requirements

## Overview
The Medicaid Work Requirements Implementation Guide (IG) provides a structured, standards-based approach for capturing, verifying, and storing exemptions and compliance data for Medicaid work requirements programs. By leveraging HL7 FHIR R4 resources, this IG allows developers to build interoperable software that can reliably manage a wide range of exemption categories, patient data, and program compliance information.

## Purpose
The IG is designed to:
* Standardize data capture for multiple exemption categories, such as age-based exemptions, pregnancy, medically frail status, veteran disability, foster youth status, and program participation (e.g., TANF, SNAP, substance use treatment).
* Enable automated verification and reporting by mapping exemption criteria to concrete FHIR resources (Patient, Condition, RelatedPerson, Coverage, Observation, EpisodeOfCare, Encounter).
* Facilitate interoperability across Medicaid systems, clinics, and managed care organizations by using internationally recognized terminologies (SNOMED CT, LOINC) and standard FHIR constructs.
* Reduce custom coding and administrative overhead by providing ready-to-use API endpoints and resource templates for software developers.

## Key Features
### Exemption Category Coverage
Age-based, pregnancy, caretakers of dependent children, medically frail, veterans, tribal affiliation (stub), TANF/SNAP compliance, substance use treatment, incarceration, foster youth, medical hardships.
Each category has a corresponding FHIR resource mapping and API endpoint for recording, updating, or querying data.

### Resource Standardization
* Uses core FHIR resources without extensions (per project requirements).
* Maps clinical and administrative data to recognized coding systems (SNOMED CT, LOINC, v3 Role Codes, custom placeholder codes when necessary).
* Supports structured recording of conditions, observations, encounters, episodes of care, and patient relationships.


### Interoperability and Reporting
* Supports reporting to Medicaid or managed care organizations by storing structured data that can be queried, aggregated, or exported.
* Facilitates compliance tracking and auditing of work requirement exemptions.


### Improved Data Quality and Consistency
* Standardized resources and code systems ensure consistent representation of exemptions across applications.
* Reduces errors in compliance verification processes.

### Scalability
* Supports multiple exemption categories simultaneously, with optional sub-resources (e.g., child disability, multiple conditions/observations).
* Easily extendable for additional program requirements or jurisdiction-specific rules.

### Regulatory Alignment
* Helps ensure software aligns with Medicaid documentation requirements and work requirement reporting standards.
* Facilitates auditability and traceability through structured FHIR data.

## Conclusion
The Medicaid Work Requirements IG provides a robust, standardized foundation for building interoperable software applications that manage exemption verification and reporting. By leveraging FHIR resources and best practices, developers can create scalable, maintainable, and compliant systems for Medicaid programs, ultimately improving data quality, operational efficiency, and patient outcomes.

## Exemption Categories — Mapping and Notes

### Age-Based Exemption (Under 19)
*   **Typical docs**: birth certificate, state ID, DMV record.
*   **FHIR resources**: `Patient.birthDate` (core).
*   **Notes**: demographic field; no extensions required. Use `Patient.identifier` for ID documents (`DocumentReference` can hold an image/scan).
*   **Provenance**: create `Provenance` linking `DocumentReference`/`Patient.identifier` to the verifying authority.

### Pregnancy Exemption
*   **Typical docs**: prenatal records, OB attestation, pregnancy registry.
*   **FHIR resources**:
    *   `Condition` with clinical pregnancy SNOMED CT code (e.g., “pregnancy” concept). VERIFY specific SNOMED code (e.g., 77386006 often used for pregnancy — confirm in SNOMED browser).
    *   `Observation` for pregnancy status (LOINC pregnancy status codes exist; VERIFY the exact LOINC you plan to use). Example pattern: `Observation.code` = LOINC(pregnancy status), `Observation.valueCodeableConcept` = {pregnancy / not pregnant / unknown}.
*   **Attachments/proof**: `DocumentReference` for prenatal records; link with `Provenance`.
*   **Note**: use `Condition` when you need a clinical problem/diagnosis; use `Observation` to represent status or tests.

### Parent / Caretaker of Dependent Child (≤13 or disabled)
*   **Docs**: birth/custody certificates, court orders, foster/custodial paperwork, child disability documentation.
*   **FHIR resources**:
    *   `RelatedPerson` to represent relationship OR `Patient.link` with `type=seealso`/`replaced-by` depending on use case. US-Core suggests `RelatedPerson` for non-patient relatives.
    *   Child disability: `Condition`/`Observation` on the child Patient resource.
*   Use `DocumentReference` for custody or birth certificates.
*   **LOINC/SNOMED**: use SNOMED for disability diagnoses, LOINC for functional status observations. VERIFY chosen codes.

### Medically Frail (Blind, Disabled, Serious SUD or Mental Conditions)
*   **Docs**: physician certification, SSA documentation, behavioral health records.
*   **FHIR resources**:
    *   `Condition` resources with SNOMED CT for the clinical conditions.
    *   `Observation` for functional status (e.g., instruments measuring functional impairment). Consider LOINC codes for SUD screening or functional status. VERIFY exact LOINC codes (e.g., PHQ/ASAM screens have known LOINC codes).
    *   `Coverage` or `Patient.identifier` may record disability determinations (e.g., SSDI).
*   **Notes**: capture date of determination and attesting clinician; use `Provenance` to show certifying authority. If "medically frail" requires a formal state/clinical attestation, represent that attestation as a `DocumentReference` and a `Provenance` entry.

### Veteran with Total Disability Rating
*   **Docs**: VA award letter, VA rating decision.
*   **FHIR resources**:
    *   `Patient.identifier` for VA ID (system URI identifying VA IDs).
    *   `Observation` or `Condition` to represent disability rating or status (with code and percentage). Use `Observation.component` for rating percent. VERIFY any LOINC code for disability rating — likely an internal/state ValueSet.
*   **Notes**: attach VA letter in `DocumentReference`; use `Provenance` to capture VA attestation.

### American Indians / Alaska Natives / California Indians
*   **Docs**: tribal enrollment card, official tribal letter.
*   **FHIR resources**:
    *   US-Core suggests Patient extensions for race/ethnicity; tribal affiliation often needs an extension (use the US-Core race/ethnicity extension or a dedicated tribal affiliation extension if available). Flag as sensitive.
    *   `DocumentReference` for tribal card, with `Provenance.agent` indicating tribal authority.
*   **Recommendation**: use agreed ValueSet for tribal affiliation, and include metadata describing who can access this field.

The US Core IG defines a Tribal Affiliation Extension that can be used on the Patient resource.

This extension represents a tribe or band with which a person associates, whether or not they are an enrolled member.

The extension includes:

A tribalAffiliation element coded from an agreed ValueSet (e.g., TribalEntityUS codes recognized by the US Bureau of Indian Affairs).

An optional isEnrolled boolean element indicating whether the person is an enrolled member of the tribe.

### TANF or SNAP Compliance
*   **Docs**: state eligibility records, SNAP/TANF letters showing compliance.
*   **FHIR resources**:
    *   `Coverage` — represent program membership (`Coverage.type`/`class`) with a ValueSet that indicates TANF or SNAP program codes.
    *   `Observation` for compliance status, if needed (e.g., `Observation.code` = “TANF work compliance”, `value` = compliant / non-compliant).
    *   `DocumentReference` for eligibility letters.
*   **Notes**: prefer authoritative state data matches (`Provenance` indicating source as state eligibility system).

### Drug or Alcohol Treatment Program Participant
*   **Docs**: enrollment verification, treatment plan, discharge summary.
*   **FHIR resources**:
    *   `Encounter` (or `EpisodeOfCare`) representing the treatment episode.
    *   `Condition` for SUD diagnosis.
    *   `DocumentReference` for treatment enrollment letter or plan.
*   **LOINC**: there are LOINC codes for treatment plans and SUD screens — VERIFY specific LOINC codes when implementing.

### Inmates / Recently Incarcerated (within 3 months)
*   **Docs**: incarceration records, discharge/release papers.
*   **FHIR resources**:
    *   No core field in `Patient` for incarceration — use a small, well-documented extension or an `Observation` resource with code indicating incarceration status and `effectivePeriod` being the incarceration interval. Prefer an agreed extension or an entry in the `Patient.resource.meta.tag` with a controlled ValueSet.
    *   `Encounter` may model periods of care during incarceration but not incarceration per se. `DocumentReference` for release papers.
*   **Privacy note**: incarceration status is sensitive PHI/SDOH — follow local privacy rules.

### Foster Care Youth & Former Foster Youth < 26
*   **Docs**: state foster care records, discharge paperwork.
*   **FHIR resources**:
    *   No core `Patient` field for foster status; use an extension aligned to US-Core / state IG or an `Observation` with standardized code for foster care status and `effectivePeriod`.
    *   `RelatedPerson` for foster parents/caretakers. `DocumentReference` for official records.
*   **Notes**: use ValueSet for statuses like “in foster care”, “former foster care”.

### Medical Hardship Exemptions (Inpatient care, travel, disaster, unemployment)
*   **Docs**: hospitalization records, FEMA disaster declarations, unemployment claim letters.
*   **FHIR resources**:
    *   `Encounter` for inpatient care; `Observation` for SDOH indicators (unemployment). LOINC has SDOH panels (e.g., 8661-1 for SDOH panel) — VERIFY codes.
    *   `DocumentReference` for hospital discharge, FEMA docs.
    *   `Provenance` to show source and type (attestation vs automated match).
