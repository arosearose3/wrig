Extension: USCoreTribalAffiliation
Id: us-core-tribalAffiliation
Title: "US Core Tribal Affiliation Extension"
Description: "Indicates tribal affiliation for American Indian/Alaska Native patients"
Context: Patient

// url is set by canonical and Id; avoid explicit assignment to prevent pattern/fixed conflict

* extension contains 
  tribalAffiliation 1..1 and
  isEnrolled 0..1

* extension[tribalAffiliation].valueCodeableConcept from http://terminology.hl7.org/ValueSet/v3-TribalEntityUS (required)
* extension[isEnrolled].valueBoolean
