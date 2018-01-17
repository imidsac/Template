if yes?("Do you want to create Scaffold for Religion and Ethnic ? (yes/no)")
  generate "scaffold", "relitions religion_name"
  generate "scaffold", "ethnics ethnic_name"

  rails_command "db:migrate" if yes?("Do you want to migrate Religion and Ethnic ? (yes/no)")

  if yes?("Do you want commit? (yes/no)")
    git :add => "."
    git :commit => "-a -m 'Adding scaffold for Religion and Ethnic'"
  end
end

if yes?("Do you want to create Scaffold for Region, cercle, commune and quartier ? (yes/no)")
  generate "scaffold", "regions name:string name_short:string position:integer code:string latitude:float longitude:float"
  generate "scaffold", "cercles region:references name:string name_short:string position:integer code:string latitude:float longitude:float"
  generate "scaffold", "communes cercle:references name:string name_short:string position:integer code:string latitude:float longitude:float"
  generate "scaffold", "quartiers commune:references name:string name_short:string position:integer code:string latitude:float longitude:float"

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
    generate "scaffold", "school quartier:references school_name contacts:hstore"
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

  if yes?("Do you want to create Scaffold for CV [training, skills] ? (yes/no)")
    generate "scaffold", "training name"
    generate "scaffold", "skills name"

    rails_command "db:migrate" if yes?("Do you want to migrate Religion and Ethnic ? (yes/no)")

    if yes?("Do you want commit? (yes/no)")
      git :add => "."
      git :commit => "-a -m 'Adding scaffold for training, skills'"
    end
  end
end


################## STORE #######################
if yes?("Do you want to do scaffold for Store ? (yes/no)")

end