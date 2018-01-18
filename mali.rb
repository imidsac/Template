if yes?("Do you want to create Scaffold for Religion and Ethnic ? (yes/no)")
  generate "scaffold", "relition religion_name"
  generate "scaffold", "ethnic ethnic_name"

  rails_command "db:migrate" if yes?("Do you want to migrate Religion and Ethnic ? (yes/no)")

  if yes?("Do you want commit? (yes/no)")
    git :add => "."
    git :commit => "-a -m 'Adding scaffold for Religion and Ethnic'"
  end
end

if yes?("Do you want to create Scaffold for Region, cercle, commune and quartier ? (yes/no)")
  generate "scaffold", "region region_name:string region_name_short:string position:integer code:string latitude:float longitude:float"
  generate "scaffold", "cercle region:references cercle_name:string cercle_name_short:string position:integer code:string latitude:float longitude:float"
  generate "scaffold", "commune cercle:references commune_name:string commune_name_short:string position:integer code:string latitude:float longitude:float"
  generate "scaffold", "quartier commune:references quartier_name:string quartier_name_short:string position:integer code:string latitude:float longitude:float"

  rails_command "db:migrate" if yes?("Do you want to migrate regions, cercles, communes and quartiers ? (yes/no)")

  if yes?("Do you want commit? (yes/no)")
    git :add => "."
    git :commit => "-a -m 'Adding scaffold regions, cercles, communes and quartiers'"
  end
end

if yes?("Do you want to create Scaffold for Person (yes/no)")
  generate "scaffold", "person first_name:string last_name:string middle_name:string sexe:string date_nai:datetime lieu_nai:string situation_family:string regime_matrimonial:string contact:hstore email:string address:string personId:hstore life:boolean"

  rails_command "db:migrate" if yes?("Do you want to migrate Person ? (yes/no)")

  if yes?("Do you want commit? (yes/no)")
    git :add => "."
    git :commit => "-a -m 'Adding scaffold Person'"
  end
end

################## Education #######################
if yes?("Do you want to do scaffold for Education ? (yes/no)")

  if yes?("Do you want to create Scaffold for cycle, level, filiere  ? (yes/no)")
    generate "scaffold", "school quartier:references school_name contacts:hstore address:string academie:string reinscription:boolean latitude:float longitude:float"
    generate "scaffold", "schoolYear annee_scolaire start_date:datetime end_date:datetime status:boolean"
    generate "scaffold", "grade grade_name grade_description"

    generate "scaffold", "cycle cycle_name"
    generate "scaffold", "level cycle:references level_name"
    generate "scaffold", "filiere level:references filiere_name"

    rails_command "db:migrate" if yes?("Do you want to migrate cycle, level and filiere ? (yes/no)")

    if yes?("Do you want commit cycle, level and filiere ? (yes/no)")
      git :add => "."
      git :commit => "-a -m 'Adding scaffold for cycle, level and filiere'"
    end
  end


    if yes?("Do you want to create Scaffold for Inscriptions ? (yes/no)")
      generate "scaffold", "enrollment school:references person_student_id:integer type_enroll:string num:string num_enroll:string school_year:references date_enroll:datetime"

      rails_command "db:migrate" if yes?("Do you want to migrate Incriptions ? (yes/no)")

      if yes?("Do you want commit Incriptions ? (yes/no)")
        git :add => "."
        git :commit => "-a -m 'Adding scaffold for Incriptions'"
      end
    end

  if yes?("Do you want to create Scaffold for CV [experience, training, skills, leisureType, leisure] ? (yes/no)")
    generate "scaffold", "experience person:references experience_name"
    generate "scaffold", "training person:references training_name"
    generate "scaffold", "areasSkill  areas_skill_name"
    generate "scaffold", "skill person:references areas_skill:references skill_name"
    generate "scaffold", "leisureType leisure_type_name"
    generate "scaffold", "leisure person:references leisur_type:references leisure_name"

    rails_command "db:migrate" if yes?("Do you want to migrate CV [experience, training, skills, leisureType, leisure] ? (yes/no)")

    if yes?("Do you want commit? (yes/no)")
      git :add => "."
      git :commit => "-a -m 'Adding scaffold for CV [experience, training, skills, leisureType, leisure]'"
    end
  end
end


################## STORE #######################
if yes?("Do you want to do scaffold for Store ? (yes/no)")

end

################## LABO PHOTO #######################
if yes?("Do you want to do scaffold for Labo photo ? (yes/no)")

end