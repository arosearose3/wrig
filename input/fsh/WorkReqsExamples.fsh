// Medicaid Work Requirements – Example Instances
// These examples align with the API categories described in the Work Requirements documentation.

// 1) Age-Based Exemption (Under 19)
Instance: WRExamplePatient
InstanceOf: WRPatient
Title: "Example Medicaid Patient (under 19)"
Description: "Patient under 19 years old"
Usage: #example
* identifier[0].system = "http://example.org/ids/patient"
* identifier[0].value = "P-WR-001"
* name[0].family = "Example"
* name[0].given[0] = "Pat"
* gender = #female
* birthDate = "2008-05-01"

// 2) Pregnancy Exemption
Instance: WRPregnancyCondition
InstanceOf: WRCondition
Title: "Pregnancy (SNOMED 77386006)"
Description: "Pregnancy condition per SNOMED CT"
Usage: #example
* subject = Reference(WRExamplePatient)
* code = http://snomed.info/sct#77386006 "Pregnant"
* clinicalStatus = http://terminology.hl7.org/CodeSystem/condition-clinical#active "Active"
* onsetDateTime = "2025-01-01"

// 3) Parent or Caretaker of Dependent Child (≤ 13 or Disabled)
Instance: WRChildPatient
InstanceOf: WRPatient
Title: "Dependent Child (under 13)"
Description: "Child patient for parent/caretaker example"
Usage: #example
* identifier[0].system = "http://example.org/ids/patient"
* identifier[0].value = "P-WR-CHILD-001"
* name[0].family = "Example"
* name[0].given[0] = "Child"
* gender = #male
* birthDate = "2015-09-01"

Instance: WRParentRelatedPerson
InstanceOf: WRRelatedPerson
Title: "Parent of Dependent Child"
Description: "RelatedPerson linking parent to child with v3-RoleCode PRN"
Usage: #example
* patient = Reference(WRChildPatient)
* relationship[0] = http://terminology.hl7.org/CodeSystem/v3-RoleCode#PRN "parent"
* name[0].family = "Caretaker"
* name[0].given[0] = "Parent"

Instance: WRChildDisability
InstanceOf: WRCondition
Title: "Child Disability (example)"
Description: "Optional child disability condition"
Usage: #example
* subject = Reference(WRChildPatient)
* code.text = "Child disability (example)"
* onsetDateTime = "2024-01-01"

// 4) Medically Frail (Blind, Disabled, SUD, Mental Health)
Instance: WRMedFrailCondition1
InstanceOf: WRCondition
Title: "Medically Frail Example Condition"
Description: "Example condition indicating medically frail status"
Usage: #example
* subject = Reference(WRExamplePatient)
* code.text = "Blindness (example)"
* onsetDateTime = "2020-01-01"

Instance: WRMedFrailObservation1
InstanceOf: WRObservation
Title: "Functional Status (example)"
Description: "Example observation supporting medically frail status"
Usage: #example
* subject = Reference(WRExamplePatient)
* code = http://example.org/codes/observation#functional-status "Functional status"
* status = #final
* effectiveDateTime = "2025-05-15"
* valueString = "Requires assistance with activities of daily living"

// 5) Veteran with Total Disability Rating
Instance: WRVeteranPatient
InstanceOf: WRPatient
Title: "Veteran with VA Identifier"
Description: "Patient with VA identifier for veteran example"
Usage: #example
* identifier[0].system = "http://va.gov/identifier/veteranId"
* identifier[0].value = "VA-0012345"
* name[0].family = "Veteran"
* name[0].given[0] = "Val"
* gender = #male
* birthDate = "1980-07-04"

Instance: WRVaDisabilityRating
InstanceOf: WRObservation
Title: "VA Disability Rating (%)"
Description: "Observation capturing VA total disability rating percent"
Usage: #example
* subject = Reference(WRVeteranPatient)
* code = http://example.org/codes/va-disability-rating#total "VA total disability rating"
* status = #final
* valueQuantity.value = 70
* valueQuantity.unit = "%"
* valueQuantity.system = "http://unitsofmeasure.org"
* valueQuantity.code = #% 
* effectiveDateTime = "2025-02-01"

// 6) American Indians, Alaska Natives, and California Indians (Stub Only) - No FHIR resources

// 7) TANF or SNAP Compliance
Instance: WRTanfCoverage
InstanceOf: WRCoverage
Title: "TANF Coverage Eligibility"
Description: "Coverage representing TANF program eligibility"
Usage: #example
* status = #active
* type.coding[0].system = "http://example.org/codes/program"
* type.coding[0].code = #TANF
* type.coding[0].display = "TANF"
* beneficiary = Reference(WRExamplePatient)
* payor[0] = Reference(WRTreatmentOrg)
* period.start = "2025-01-01"
* period.end = "2025-12-31"

Instance: WRProgramCompliance
InstanceOf: WRObservation
Title: "Program Compliance"
Description: "Observation indicating TANF/SNAP compliance"
Usage: #example
* subject = Reference(WRExamplePatient)
* code = http://example.org/codes/program-compliance#compliant "Program compliance"
* status = #final
* valueBoolean = true
* effectiveDateTime = "2025-03-31"

// 8) Drug or Alcohol Treatment Program Participant
Instance: WRTreatmentOrg
InstanceOf: Organization
Title: "Managing Organization (Treatment Program)"
Description: "Organization managing the treatment episode"
Usage: #example
* name = "Community Recovery Clinic"

Instance: WRTreatmentEpisode
InstanceOf: WREpisodeOfCare
Title: "Treatment Program EpisodeOfCare"
Description: "Episode of care for substance use treatment"
Usage: #example
* status = #active
* type[0] = http://example.org/codes/episode-type#SUBSTANCE-USE-TREATMENT "Substance use treatment"
* patient = Reference(WRExamplePatient)
* managingOrganization = Reference(WRTreatmentOrg)
* period.start = "2025-03-01"
* period.end = "2025-06-01"

// 9) Incarceration or Recently Incarcerated (≤ 3 months)
Instance: WRIncarcerationStatus
InstanceOf: WRObservation
Title: "Incarceration Status"
Description: "Observation representing incarceration period/status"
Usage: #example
* subject = Reference(WRExamplePatient)
* code = http://example.org/codes/social-status#incarceration "Incarceration status"
* status = #final
* valueBoolean = true
* effectivePeriod.start = "2025-04-01"
* effectivePeriod.end = "2025-06-30"

// 10) Foster Care Youth and Former Foster Youth < 26
Instance: WRFosterCareStatus
InstanceOf: WRObservation
Title: "Foster Care Status"
Description: "Observation representing foster care status"
Usage: #example
* subject = Reference(WRExamplePatient)
* code = http://example.org/codes/social-status#foster-care "Foster care status"
* status = #final
* valueCodeableConcept = http://terminology.hl7.org/CodeSystem/v2-0136#Y "Yes"
* effectiveDateTime = "2025-05-10"

// 11) Medical Hardship Exemptions (Inpatient Care, Travel for Care, Disaster, Unemployment)
Instance: WRHospitalOrg
InstanceOf: Organization
Title: "Hospital (Service Provider)"
Description: "Hospital organization for inpatient encounter"
Usage: #example
* name = "General Hospital"

Instance: WRInpatientEncounter
InstanceOf: WREncounter
Title: "Inpatient Encounter"
Description: "Encounter representing inpatient care (IMP)"
Usage: #example
* status = #finished
* class = http://terminology.hl7.org/CodeSystem/v3-ActCode#IMP "inpatient encounter"
* subject = Reference(WRExamplePatient)
* serviceProvider = Reference(WRHospitalOrg)
* period.start = "2025-02-10"
* period.end = "2025-02-14"

Instance: WRTravelForCare
InstanceOf: WRObservation
Title: "Travel for Care"
Description: "Observation representing required travel for care"
Usage: #example
* subject = Reference(WRExamplePatient)
* code = http://example.org/codes/hardship#travel-for-care "Travel for care"
* status = #final
* valueBoolean = true
* effectiveDateTime = "2025-02-09"
* note.text = "Required travel to tertiary facility"

Instance: WRDisaster
InstanceOf: WRObservation
Title: "Declared Disaster"
Description: "Observation representing disaster impact"
Usage: #example
* subject = Reference(WRExamplePatient)
* code = http://example.org/codes/hardship#disaster "Declared disaster"
* status = #final
* valueString = "FEMA-DR-9999"
* effectiveDateTime = "2025-08-01"

Instance: WRUnemployment
InstanceOf: WRObservation
Title: "Unemployment Status"
Description: "Observation representing unemployment status"
Usage: #example
* subject = Reference(WRExamplePatient)
* code = http://example.org/codes/hardship#unemployment-status "Unemployment status"
* status = #final
* valueBoolean = true
* effectiveDateTime = "2025-01-15"
