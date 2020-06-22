shared_context '転職活動者と応募企業' do
  let!(:user) {create(:user)}
  let!(:entried_company_user){ create(:user, :company_user)}
  let!(:company_user){ create(:user, :company_user)}
  before do
    user.company_users << entried_company_user
  end
end
