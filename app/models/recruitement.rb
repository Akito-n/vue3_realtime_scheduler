# == Schema Information
#
# Table name: recruitements
#
#  id                 :uuid             not null, primary key
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  company_user_id    :uuid             not null
#  individual_user_id :uuid             not null
#
# Indexes
#
#  index_recruitements_on_individual_user_id_and_company_user_id  (individual_user_id,company_user_id)
#
# Foreign Keys
#
#  fk_rails_...  (company_user_id => users.id)
#  fk_rails_...  (individual_user_id => users.id)
#
class Recruitement < ApplicationRecord
  belongs_to :individual_user, class_name: :User
  belongs_to :company_user, class_name: :User

  validates :individual_user_id, uniqueness: { scope: :company_user_id }
end
