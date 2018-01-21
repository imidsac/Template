if yes?("Do you want to create Scaffold for Service (yes/no)")
  generate "scaffold", "service name:string"
end


if yes?("Do you want to create Scaffold for Pilgrimage (yes/no)")
  generate "scaffold", "pilgrimage pilgrimable:references:polymorphic "
end

if yes?("Do you want to create Scaffold for Contact (yes/no)")
  generate "scaffold", "contact contactable:references:polymorphic"
end

if yes?("Do you want to create Scaffold for Contact (yes/no)")
  generate "scaffold", "contact contactable:references:polymorphic"
end

rails_command "db:migrate" if yes?("Do you want to migrate? (yes/no)")

if yes?("Do you want commit? (yes/no)")
  git :add => "."
  git :commit => "-a -m 'Adding Scaffold Mosques'"
end
