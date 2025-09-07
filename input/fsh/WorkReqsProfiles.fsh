// Medicaid Work Requirements – Profiles
// No extensions used per requirement; profiles are minimal constraints for core resources.

Profile: WRPatient
Parent: Patient
Id: WRPatient
Title: "Work Requirements Patient"
Description: "Patient profile for Medicaid Work Requirements"
* birthDate 1..1 MS
* identifier MS

Profile: WRCondition
Parent: Condition
Id: WRCondition
Title: "Work Requirements Condition"
Description: "Condition resource for pregnancy, medically frail, child disability, etc."
* code 1..1 MS
* subject 1..1 MS
* clinicalStatus MS
* onset[x] MS
* abatement[x] MS

Profile: WRRelatedPerson
Parent: RelatedPerson
Id: WRRelatedPerson
Title: "Work Requirements Related Person"
Description: "Represents parent/caretaker relationship to dependent child"
* patient 1..1 MS
* relationship 1..* MS

Profile: WRObservation
Parent: Observation
Id: WRObservation
Title: "Work Requirements Observation"
Description: "Observation for program compliance, incarceration, foster status, functional status"
* code 1..1 MS
* subject 1..1 MS
* value[x] 1..1 MS
* effective[x] MS

Profile: WRCoverage
Parent: Coverage
Id: WRCoverage
Title: "Work Requirements Coverage"
Description: "Represents TANF/SNAP program coverage eligibility"
* status 1..1 MS
* type MS
* beneficiary 1..1 MS
* period MS

Profile: WREpisodeOfCare
Parent: EpisodeOfCare
Id: WREpisodeOfCare
Title: "Work Requirements EpisodeOfCare"
Description: "Represents participation in treatment programs"
* status MS
* type MS
* patient 1..1 MS
* managingOrganization MS
* period MS

Profile: WREncounter
Parent: Encounter
Id: WREncounter
Title: "Work Requirements Encounter"
Description: "Represents inpatient care or medical hardship encounters"
* status MS
* class 1..1 MS
* subject 1..1 MS
* period MS
* serviceProvider MS
