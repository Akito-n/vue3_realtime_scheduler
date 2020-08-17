namespace :scedule do
  desc '予定のリセット'
  task :all_reset => :environment do
    ActiveRecord::Base.transaction do
      Schedule.destroy_all
      BlankSchedule.destroy_all
    end
  end
end
