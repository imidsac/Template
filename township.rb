if yes?("Do you want to do scaffold for Township ? (yes/no)")

  ###### Partie
  if yes?("Do you want to create Scaffold for Country, Region, cercle, commune and quartier ? (yes/no)")
    generate "scaffold", "country country_name:string country_name_short:string country_devise:string position:integer code:string latitude:float longitude:float"
    generate "scaffold", "region country:references region_name:string region_name_short:string position:integer code:string latitude:float longitude:float"
    generate "scaffold", "cercle region:references cercle_name:string cercle_name_short:string position:integer code:string latitude:float longitude:float"
    generate "scaffold", "commune cercle:references commune_name:string commune_name_short:string position:integer code:string latitude:float longitude:float"
    generate "scaffold", "quartier commune:references quartier_name:string quartier_name_short:string position:integer code:string latitude:float longitude:float"

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


  ###### People
  if yes?("Do you want to create Scaffold for Person (yes/no)")
    generate "scaffold", "person religion:references ethnic:references first_name:string last_name:string middle_name:string sexe:string date_nai:datetime lieu_nai:string situation_family:string regime_matrimonial:string contacts:jsonb address:string personId:jsonb life:boolean"

    rails_command "db:migrate" if yes?("Do you want to migrate Person ? (yes/no)")

    if yes?("Do you want commit? (yes/no)")
      git :add => "."
      git :commit => "-a -m 'Adding scaffold People'"
    end
  end

end

