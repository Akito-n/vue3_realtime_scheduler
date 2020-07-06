# == Schema Information
#
# Table name: blank_schedules
#
#  id               :uuid             not null, primary key
#  end_at           :datetime
#  schedulable_type :string           not null
#  start_at         :datetime
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  schedulable_id   :uuid             not null
#
# Indexes
#
#  index_blank_schedules_on_schedulable_type_and_schedulable_id  (schedulable_type,schedulable_id)
#
class BlankSchedule < ApplicationRecord
  belongs_to :schedulable, polymorphic: true

  validate :check_schedule
  validates_with CheckScheduleValidator

  def self.hollow_out!(schedulables, start_at:, end_at:)
    where(schedulable: schedulables).find_each do |blank_schedule|
      #開始時間が既存のレコードのレンジ内にある時
      if blank_schedule.start_at <= start_at && start_at <= blank_schedule.end_at
        blank_schedule.destroy!
        if blank_schedule.start_at < start_at
          create!(start_at: blank_schedule.start_at, end_at: start_at, schedulable: blank_schedule.schedulable)
        end
      end

      # 終了時間が既存のレコードのレンジ内にある場合
      if blank_schedule.start_at < end_at && end_at < blank_schedule.end_at
        blank_schedule.destroy!
        if blank_schedule.end_at > end_at
          create!(start_at: end_at, end_at: blank_schedule.end_at, schedulable: blank_schedule.schedulable)
        end
      end

      #既存のレコードが新規作成予定のスケジュールの中に入っている場合もエラーを出す
      if (start_at < blank_schedule.start_at && blank_schedule.start_at < end_at) || (start_at < blank_schedule.end_at && blank_schedule.end_at < end_at)
        blank_schedule.destroy!
      end
    end
  end

  #MEMO: scheduleとメソッドを合わせる
  def requester
    schedulable
  end

  def requester_id
    schedulable_id
  end

  def check_schedule
    if start_at > end_at
      errors.add(:start_at,'は終了時間よりも前に設定してください。')
    end
  end

  def status
    :pending
  end

  # HACK: punditとかにしたほうが良さそう
  def can_read?(user)
    user.schedulable_array.include?(schedulable) || user.schedulable_array.include?(schedulable)
  end

  def can_write?(user)
    user.my_schedulable_array.include?(schedulable)
  end
end
