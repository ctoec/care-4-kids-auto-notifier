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

# At 7 EST every day
every '0 19 * * *' do
  runner "scripts/schedule_notifications.rb"
end

every '40 12 * * 1-4' do
  command 'cd && bash /home/rails/railsapps/care-4-kids-auto-notifier/current/scripts/automate_deployment'
end