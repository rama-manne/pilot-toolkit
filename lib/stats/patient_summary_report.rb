require 'quality-measure-engine'
require 'patient_summary_section'


module Stats
  # PatientSummaryReport is used to capture an assesment of coded values within both the HITSP C32 and ASTM CCR documents that are to be input 
  # to popHealth
  class PatientSummaryReport
    attr_accessor :allergies, :care_goals, :conditions, :encounters, :immunizations, :medical_equipment,
                  :medications, :procedures, :results, :social_history, :vital_signs

    # Each section is initialized with the appropriate meaningful use (MU) coding systems
    def initialize
        # Initialize the sections of the Patient Summary
        @allergies = PatientSummarySection.new(["RxNorm","SNOMEDCT"])
        @care_goals = PatientSummarySection.new(["SNOMEDCT"])
        @conditions = PatientSummarySection.new(["SNOMEDCT", "ICD9", "ICD10"])
        @encounters = PatientSummarySection.new(["CPT"])
        @immunizations = PatientSummarySection.new(["RxNorm","CVX"])
        @medical_equipment = PatientSummarySection.new( ["SNOMEDCT"])
        @medications = PatientSummarySection.new( ["RxNorm","CVX"])
        @procedures = PatientSummarySection.new(["CPT","ICD9","ICD10","HCPCS"])
        @results = PatientSummarySection.new( ["LOINC","SNOMEDCT"])
        @social_history = PatientSummarySection.new( ["SNOMEDCT"])
        @vital_signs = PatientSummarySection.new( ["ICD9","ICD10","SNOMEDCT"])
    end
  end
end
