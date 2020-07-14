# == Schema Information
#
# Table name: recruitements
#
#  id                                   :uuid             not null, primary key
#  stage(応募の状態（1次面接通過など）) :integer          default("first"), not null
#  created_at                           :datetime         not null
#  updated_at                           :datetime         not null
#  company_user_id                      :uuid             not null
#  individual_user_id                   :uuid             not null
#  occupation_id                        :uuid             not null
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
require 'rails_helper'

RSpec.describe Recruitement, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
