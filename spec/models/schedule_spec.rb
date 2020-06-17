# == Schema Information
#
# Table name: schedules
#
#  id           :uuid             not null, primary key
#  approved_at  :datetime
#  end_at       :datetime
#  start_at     :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  requester_id :uuid             not null
#  responder_id :uuid             not null
#
# Indexes
#
#  index_schedules_on_requester_id_and_responder_id  (requester_id,responder_id)
#
# Foreign Keys
#
#  fk_rails_...  (requester_id => users.id)
#  fk_rails_...  (responder_id => users.id)
#
require 'rails_helper'

RSpec.describe Schedule, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
