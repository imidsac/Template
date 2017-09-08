if yes?("Do you want to create Scaffold for Service (yes/no)")
  generate "scaffold", "service name:string"
end

if yes?("Do you want to create Scaffold for Staff (yes/no)")
  generate "scaffold", "staff service:references first_name:string last_name:string surnom:string sexe:string date_nai:datetime lieu_nai:string situation_family:string regime_matrimonial:string contact:string email:string address:string n_nina:string n_cin:string profession:string life:boolean"
end

if yes?("Do you want to create Scaffold for Partner (yes/no)")
  generate "scaffold", "partner company:string first_name:string last_name:string surnom:string sexe:string date_nai:datetime lieu_nai:string situation_family:string regime_matrimonial:string contact:string email:string address:string n_nina:string n_cin:string profession:string life:boolean "
end

if yes?("Do you want to create Scaffold for Custom (yes/no)")
  generate "scaffold", "custom first_name:string last_name:string surnom:string sexe:string date_nai:datetime lieu_nai:string situation_family:string regime_matrimonial:string contact:string email:string address:string n_nina:string n_cin:string profession:string life:boolean"
end

if yes?("Do you want to create Scaffold for Pilgrimage (yes/no)")
  generate "scaffold", "pilgrimage pilgrimable:references:polymorphic "
end

rails_command "db:migrate" if yes?("Do you want to migrate? (yes/no)")

if yes?("Do you want commit? (yes/no)")
  git :add => "."
  git :commit => "-a -m 'Adding Scaffold Mosques'"
end
