# == Schema Information
#
# Table name: recruitements
#
#  id                                                   :uuid             not null, primary key
#  is_fixed(応募済みの案件の面接日が全て確定しているか) :boolean          default(FALSE)
#  stage_count(応募回数（ex: 「1」次面接）)             :integer          default(1), not null
#  created_at                                           :datetime         not null
#  updated_at                                           :datetime         not null
#  company_user_id                                      :uuid             not null
#  individual_user_id                                   :uuid             not null
#  occupation_id                                        :uuid             not null
#
# Indexes
#
#  index_recruitements_on_individual_user_id_and_company_user_id  (individual_user_id,company_user_id)
#  index_recruitements_on_occupation_id                           (occupation_id)
#
# Foreign Keys
#
#  fk_rails_...  (company_user_id => users.id)
#  fk_rails_...  (individual_user_id => users.id)
#  fk_rails_...  (occupation_id => occupations.id)
#
FactoryBot.define do
  factory :recruitement do
    individual_user { nil }
    company_user { nil }
  end
end
