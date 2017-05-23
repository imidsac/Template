if yes?("Do you want to create Scaffold for Station police? (yes/no)")
  generate "scaffold", "stationPolices name:string address:string quartier:references "
end

if yes?("Do you want to create Scaffold for Engines ? (yes/no)")
  generate "scaffold", "engines name:string description:text"
end

if yes?("Do you want to create Scaffold for statements ? (yes/no)")
  generate "scaffold", "statements user:references engin:references colore:string description:text"
end

if yes?("Do you want to create Scaffold for Found Engines ? (yes/no)")
  generate "scaffold", "foundEngines user:references statement:references date_found:datetime"
end

rails_command "db:migrate" if yes?("Do you want to migrate? (yes/no)")