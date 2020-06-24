# == Schema Information
#
# Table name: occupations
#
#  id              :uuid             not null, primary key
#  name            :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  recruitement_id :uuid             not null
#  user_id         :uuid             not null
#
# Indexes
#
#  index_occupations_on_recruitement_id  (recruitement_id)
#  index_occupations_on_user_id          (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (recruitement_id => recruitements.id)
#  fk_rails_...  (user_id => users.id)
#
class Occupation < ApplicationRecord
end
