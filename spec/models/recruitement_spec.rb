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
#  index_recruitements_on_company_user_id     (company_user_id)
#  index_recruitements_on_individual_user_id  (individual_user_id)
#
# Foreign Keys
#
#  fk_rails_...  (company_user_id => users.id)
#  fk_rails_...  (individual_user_id => users.id)
#
require 'rails_helper'

RSpec.describe Recruitement, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
