################## Education #######################
if yes?("Do you want to do scaffold for Education ? (yes/no)")

  ###### Partie
  if yes?("Do you want to create Scaffold for Country, Region, cercle, commune and quartier ? (yes/no)")
    generate "scaffold", "country country_name:string country_name_short:string country_devise:string position:integer code:string latitude:float longitude:float"
    generate "scaffold", "region country:references region_name:string region_name_short:string position:integer code:string latitude:float longitude:float"
    generate "scaffold", "cercle region:references cercle_name:string cercle_name_short:string position:integer code:string latitude:float longitude:float"
    generate "scaffold", "commune cercle:references commune_name:string commune_name_short:string position:integer code:string latitude:float longitude:float"
    generate "scaffold", "quartier commune:references quartier_name:string quartier_name_short:string position:integer code:string latitude:float longitude:float"

    # generate "scaffold", "agency quartier:references agency_name:string agency_name_short:string position:integer code:string latitude:float longitude:float"

    rails_command "db:migrate" if yes?("Do you want to migrate country regions, cercles, communes and quartiers ? (yes/no)")

    if yes?("Do you want commit? (yes/no)")
      git :add => "."
      git :commit => "-a -m 'Adding scaffold country regions, cercles, communes, quartiers'"
    end
  end

  ###### Ethnic and Religion
  if yes?("Do you want to create Scaffold for Religion and Ethnic ? (yes/no)")
    generate "scaffold", "religion religion_name"
    generate "scaffold", "ethnic ethnic_name"

    rails_command "db:migrate" if yes?("Do you want to migrate Religion and Ethnic ? (yes/no)")

    if yes?("Do you want commit? (yes/no)")
      git :add => "."
      git :commit => "-a -m 'Adding scaffold for Religion and Ethnic'"
    end
  end

  ###### Companies
  if yes?("Do you want to create Scaffold for Companies ? (yes/no)")
    generate "scaffold", "company name contacts:jsonb address settings:jsonb"
    rails_command "db:migrate" if yes?("Do you want to migrate Companies ? (yes/no)")

    if yes?("Do you want commit Companies ? (yes/no)")
      git :add => "."
      git :commit => "-a -m 'Adding scaffold for Companies'"
    end
  end


  ###### Training
  if yes?("Do you want to create Scaffold for Training ? (yes/no)")
    generate "scaffold", "training training_position:integer training_name training_name_short training_description"
    rails_command "db:migrate" if yes?("Do you want to migrate Companies ? (yes/no)")

    if yes?("Do you want commit Training ? (yes/no)")
      git :add => "."
      git :commit => "-a -m 'Adding scaffold for Training'"
    end
  end


  ###### school cycle, level and filiere
  if yes?("Do you want to create Scaffold for school cycle, level, filiere  ? (yes/no)")
    generate "scaffold", "school quartier:references school_position:integer school_name contacts:jsonb address:string academie:string reinscription:boolean latitude:float longitude:float settings:jsonb"
    # generate "scaffold", "grade grade_name grade_description"

    generate "scaffold", "cycle cycle_position:integer cycle_name cycle_name_short cycle_description fees:jsonb fee_registration:decimal fee_re_registration:decimal private_tuition_fees:decimal state_tuition_fees:decimal cycle_status:boolean cycle_characteristics:jsonb"
    generate "scaffold", "level cycle:references training:references level_name level_name_short level_description fees:jsonb fee_registration:decimal fee_re_registration:decimal private_tuition_fees:decimal state_tuition_fees:decimal level_status:boolean level_characteristics:jsonb"
    # generate "scaffold", "serie serie_name"
    generate "scaffold", "filiere filiere_name filiere_name_short filiere_description fees:jsonb fee_registration:decimal fee_re_registration:decimal private_tuition_fees:decimal state_tuition_fees:decimal filiere_status:boolean filiere_characteristics:jsonb"

    generate "scaffold", "schoolYear cycle:references training:references annee_scolaire start_date:datetime end_date:datetime fees:jsonb fee_registration:decimal fee_re_registration:decimal private_tuition_fees:decimal state_tuition_fees:decimal status:boolean school_year_characteristics:jsonb "

    rails_command "db:migrate" if yes?("Do you want to migrate cycle, level and filiere ? (yes/no)")

    if yes?("Do you want commit cycle, level and filiere ? (yes/no)")
      git :add => "."
      git :commit => "-a -m 'Adding scaffold for cycle, level and filiere'"
    end
  end

  ###### People
  if yes?("Do you want to create Scaffold for Person (yes/no)")
    generate "scaffold", "person religion:references ethnic:references first_name:string last_name:string middle_name:string sexe:string date_nai:datetime lieu_nai:string situation_family:string regime_matrimonial:string contacts:jsonb address:string personId:jsonb life:boolean"

    rails_command "db:migrate" if yes?("Do you want to migrate Person ? (yes/no)")

    if yes?("Do you want commit? (yes/no)")
      git :add => "."
      git :commit => "-a -m 'Adding scaffold People'"
    end
  end

  ###### Inscriptions
  if yes?("Do you want to create Scaffold for Inscriptions ? (yes/no)")
    generate "scaffold", "enrollment school:references staff_id:integer student_id:integer type_enroll:string num:string num_enroll:string date_enroll:datetime filiere:references options:jsonb"

    rails_command "db:migrate" if yes?("Do you want to migrate Incriptions ? (yes/no)")

    if yes?("Do you want commit Incriptions ? (yes/no)")
      git :add => "."
      git :commit => "-a -m 'Adding scaffold for Incriptions'"
    end
  end

  ###### CV [experience, training, skills, leisureType, leisure]
  if yes?("Do you want to create Scaffold for CV [experience, training, skills, leisureType, leisure] ? (yes/no)")
    generate "scaffold", "experience person:references experience_name"
    generate "scaffold", "training person:references training_name"
    generate "scaffold", "areasSkill  areas_skill_name"
    generate "scaffold", "skill person:references areas_skill:references skill_name"
    generate "scaffold", "leisureType leisure_type_name"
    generate "scaffold", "leisure person:references leisure_type:references leisure_name"

    rails_command "db:migrate" if yes?("Do you want to migrate CV [experience, training, skills, leisureType, leisure] ? (yes/no)")

    if yes?("Do you want commit? (yes/no)")
      git :add => "."
      git :commit => "-a -m 'Adding scaffold for CV [experience, training, skills, leisureType, leisure]'"
    end
  end

end

