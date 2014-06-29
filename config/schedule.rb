set :environment, :development

every 5.minutes do
  command "echo 'hola 5 mins testing'"
end

every :hour do 
  runner "Work.start"
end
