# == Schema Information
#
# Table name: blank_schedules
#
#  id         :uuid             not null, primary key
#  end_at     :datetime
#  start_at   :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :uuid             not null
#
# Indexes
#
#  index_blank_schedules_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
require 'rails_helper'

RSpec.describe BlankSchedule, type: :model do
  describe 'validation' do
    include_context '転職活動者と応募企業'
    context '正常系' do
      subject(:new_schedule){ user.blank_schedules.build(start_at: Time.zone.now.beginning_of_day, end_at: Time.zone.now.beginning_of_day + 1.hour)}
      it '予定を新規に登録することができる' do
        is_expected.to be_valid
      end

      it '応募した会社が登録している予定とは関係なく同時間帯に空き予定を入れることができる' do
        entried_company_user.blank_schedules.create(start_at: Time.zone.now.beginning_of_day, end_at: Time.zone.now.beginning_of_day + 1.hour)
        is_expected.to be_valid
      end
    end

    context '異常系' do
      subject(:schedule){ user.blank_schedules.build }
      context '開始時間と終了時間が一緒のデータは登録できない' do
        #TODO
      end
    end
  end
end
