set :environment, :development
set :output, "log/schedule.log"

job_type :runner,  "cd :path && bin/rails runner -e :environment :task :output"
job_type :command, ":task :output"

every :hour do 
  runner "Work.start"
end
