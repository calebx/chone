# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever
set :environment, :development

every 5.minutes do
  command "echo 'hola 5 mins testing'"
end

every 1.day, at: '10:03am' do
  runner "Work.start"
end
every 1.day, at: '11:03am' do
  runner "Work.start"
end
every 1.day, at: '12:03am' do
  runner "Work.start"
end

every 1.day, at: '03:03am' do
  runner "Work.start"
end
every 1.day, at: '09:03am' do
  runner "Work.start"
end
every 1.day, at: '3:03pm' do
  runner "Work.start"
end
every 1.day, at: '9:03pm' do
  runner "Work.start"
end

