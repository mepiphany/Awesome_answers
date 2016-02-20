namespace :send_reports do

  desc "Send all reports in the system"
  task :send_all => :environment do
    puts Cowsay.say("Sending Reports")
  end

end
