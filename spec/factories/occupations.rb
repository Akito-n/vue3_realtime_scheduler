# == Schema Information
#
# Table name: occupations
#
#  id         :uuid             not null, primary key
#  color      :string           default("orange"), not null
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :uuid             not null
#
# Indexes
#
#  index_occupations_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
FactoryBot.define do
  factory :occupation do
    
  end
end
