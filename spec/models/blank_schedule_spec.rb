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
    context '正常系' do
      include_context '転職活動者と応募企業'
      subject(:new_schedule){ user.blank_schedules.build(start_at: Time.zone.now.beginning_of_day, end_at: Time.zone.now.beginning_of_day + 1.hour)}
      it '予定を新規に登録することができる' do
        is_expected.to be_valid
      end

      it '応募した会社が登録している予定とは関係なく同時間帯に空き予定を入れることができる' do
        entried_company_user.blank_schedules.create(start_at: Time.zone.now.beginning_of_day, end_at: Time.zone.now.beginning_of_day + 1.hour)
        is_expected.to be_valid
      end
    end

    context '正常系、既存予定あるとき' do
      include_context '転職者による予定記入済み'

      it '開始時間と終了時間が既存のレコードの開始終了に被っている時も予定を入れることができる' do
        #ex: ユーザーが10:00~11:00と 12:00~13:00時で予定を埋めている場合に、その合間の11:00~12:00時で予定を埋めることができる
        correct_record = user.blank_schedules.build(start_at: Time.zone.now.beginning_of_day + 1.hour, end_at: Time.zone.now.beginning_of_day + 2.hour)
        expect(correct_record).to be_valid
      end
    end

    context '異常系' do
      include_context '転職者による予定記入済み'
      let(:new_schedule){ user.blank_schedules.build()}
      let(:schedule){user.blank_schedules.first}

      before do
      end

      it '全く同じ予定の予定は入れることができない' do
        new_schedule.start_at = schedule.start_at
        new_schedule.end_at = schedule.end_at

        expect(new_schedule.valid?).to be_falsy
      end

      it '開始時間が既存の予定に被ってる' do
        new_schedule.start_at = schedule.start_at + 30.minutes
        new_schedule.end_at = schedule.end_at + 2.hour

        expect(new_schedule.valid?).to be_falsy
      end
      it '終了時間が既存の予定に被っている' do
        new_schedule.start_at = schedule.start_at - 2.hour
        new_schedule.end_at = schedule.end_at - 30.minutes

        expect(new_schedule.valid?).to be_falsy
      end

      it '開始時間と終了時間が既存のレコードに内包されている' do
        new_schedule.start_at = schedule.start_at
        new_schedule.end_at = schedule.end_at - 30.minutes

        expect(new_schedule.valid?).to be_falsy
      end
      it '開始時間と終了時間が一緒のもの' do
        new_schedule.start_at = Time.zone.now.beginning_of_day
        new_schedule.end_at = Time.zone.now.beginning_of_day

        expect(new_schedule.valid?).to be_falsy
      end
    end
  end
end
