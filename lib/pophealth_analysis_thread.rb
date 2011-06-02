import "java.lang.Thread"

class PophealthAnalysisThread < Thread

  def initialize
    @schematron_validator = Validation::ValidatorRegistry.c32_schematron_validator
    @schema_validator = Validation::ValidatorRegistry.c32_xml_schema_validator
  end

  def set_parent_jframe(parent_jframe)
    @pophealth_jframe = parent_jframe
  end

  def set_import_directory(import_directory)
    @import_directory = import_directory
  end

  def run
    analysis_results = create_analysis_results
    file_counter = 0
    file_validation_errors = 0
    files = @import_directory.listFiles()
    files.each do |next_file|
      puts "Considering " + next_file.to_s
      continuity_of_care_record = File.read(next_file.get_path)
      if (PophealthImporterListener.continuity_of_care_mode == :c32_mode)
        c32_schema_errors= @schema_validator.validate(continuity_of_care_record)
        c32_schematron_errors = @schematron_validator.validate(continuity_of_care_record)
        if (c32_schema_errors.size > 0 || c32_schematron_errors.size > 0)
          file_validation_errors += 1
        end
        doc = Nokogiri::XML(continuity_of_care_record)
        doc.root.add_namespace_definition('cda', 'urn:hl7-org:v3')
        #psr = Stats::PatientSummaryReport.from_c32(doc)
      else
        puts "consider CCR file"
      end
      file_counter += 1
      @pophealth_jframe.set_analysis_progress_bar((file_counter.to_f)/(files.size.to_f))
      @pophealth_jframe.get_content_pane.repaint()
      analysis_results["file_validation"] = (file_validation_errors.to_f)/(files.size.to_f)
    end
    @pophealth_jframe.update_analysis_results(analysis_results)
    @pophealth_jframe.enable_play
  end

  def create_analysis_results
    analysis_results = {"file_validation" => 0.0,
                        "allergies_present" => 0.0,
                        "allergies_coded" => 0.0,
                        "allergies_mu_compliant" => 0.0,
                        "encounters_present" => 0.0,
                        "encounters_coded" => 0.0,
                        "encounters_mu_compliant" => 0.0,
                        "conditions_present" => 0.0,
                        "conditions_coded" => 0.0,
                        "conditions_mu_compliant" => 0.0,                        
                        "lab_results_present" => 0.0,
                        "lab_results_coded" => 0.0,
                        "lab_results_mu_compliant" => 0.0,
                        "immunizations_present" => 0.0,
                        "immunizations_coded" => 0.0,
                        "immunizations_mu_compliant" => 0.0,
                        "medications_present" => 0.0,
                        "medications_coded" => 0.0,
                        "medications_mu_compliant" => 0.0,
                        "procedures_present" => 0.0,
                        "procedures_coded" => 0.0,
                        "procedures_mu_compliant" => 0.0,
                        "vital_signs_present" => 0.0,
                        "vital_signs_coded" => 0.0,
                        "vital_signs_mu_compliant" => 0.0}
  end

end