set :environment, :development
set :output, "log/schedule.log"

job_type :runner,  "cd :path && bin/rails runner -e :environment :task >> :output"
job_type :command, ":task >> :output"

every 5.minutes do
  command "echo 'hola 5 mins testing'"
end

every :hour do 
  runner "Work.start"
end
