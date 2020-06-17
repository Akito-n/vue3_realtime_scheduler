namespace :recruitment do
  desc '応募する'
  task :entry, [:email1, :email2] => :environment do |task, args|
    user1 = User.find_by(email: args.email1)
    user2 = User.find_by(email: args.email2)
    individual_user = user1.individual? ? user1 : user2
    company_user = user1.company? ? user1 : user2
    individual_user.company_users << company_user
  end
end
