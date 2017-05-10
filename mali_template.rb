
if yes?("Do you want to create Scaffold for Region, cercle, commune and quartier ? (yes/no)")
  generate "scaffold", "regions name:string name_short:string position:integer code:string latitude:float longitude:float"
  generate "scaffold", "cercles region:references name:string name_short:string position:integer code:string latitude:float longitude:float"
  generate "scaffold", "communes cercle:references name:string name_short:string position:integer code:string latitude:float longitude:float"
  generate "scaffold", "quartiers commune:references name:string name_short:string position:integer code:string latitude:float longitude:float"
end

rails_command "db:migrate" if yes?("Do you want to migrate? (yes/no)")

if yes?("Do you want commit? (yes/no)")
  git :add => "."
  git :commit => "-a -m 'Adding regions, cercles, communes and quartiers'"
end