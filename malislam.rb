if yes?("Do you want to create Scaffold for Mosque? (yes/no)")
  generate "scaffold", "mosques quartier:references name:string name_short:string address:string position:integer code:string latitude:float longitude:float"
end

if yes?("Do you want to create Scaffold for Office (yes/no)")
  generate "scaffold", "offices mosque:references name:string name_short:string"
end

if yes?("Do you want to create Scaffold for Person (yes/no)")
  generate "scaffold", "person first_name:string last_name:string surnom:string sexe:string date_nai:datetime lieu_nai:string situation_family:string regime_matrimonial:string contact:string email:string address:string n_nina:string n_cin:string life:boolean"
end

rails_command "db:migrate" if yes?("Do you want to migrate? (yes/no)")

if yes?("Do you want commit? (yes/no)")
  git :add => "."
  git :commit => "-a -m 'Adding Scaffold Mosques'"
end
