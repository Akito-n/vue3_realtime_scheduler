shared_context '転職活動者と応募企業' do
  let!(:user) {create(:user)}
  let!(:entried_company_user){ create(:user, :company_user)}
  let!(:company_user){ create(:user, :company_user)}
  before do
    user.company_users << entried_company_user
  end
end

shared_context '転職者による予定記入済み' do
  include_context '転職活動者と応募企業'
  before do
    user.blank_schedules.create(start_at: Time.zone.now.beginning_of_day, end_at: Time.zone.now.beginning_of_day + 1.hour)
    user.blank_schedules.create(start_at: Time.zone.now.beginning_of_day + 2.hour, end_at: Time.zone.now.beginning_of_day + 3.hour)
  end
end
