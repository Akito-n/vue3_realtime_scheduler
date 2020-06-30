class CheckScheduleValidator < ActiveModel::Validator
  def validate(record)
    record.errors.add(:start_at, 'と終了時間が同じです。') and return if record.start_at == record.end_at
    BlankSchedule.where(schedulable: record.schedulable).map do |schedule|
      #既存予定と同じ時間帯のレコードがある場合はエラー
      record.errors.add(:start_at, 'と終了時間が同じ予定がすでに登録されています。') if schedule.start_at == record.start_at && schedule.end_at == record.end_at
      #開始時間が既存のレコードのレンジ内にある時か,終了時間が既存のレコードのレンジ内にある場合はエラー
      if (schedule.start_at < record.start_at && record.start_at < schedule.end_at) || (schedule.start_at < record.end_at && record.end_at < schedule.end_at)
        record.errors.add(:start_at, 'か終了時間が既存の予定と重複しています。')
        break
      end
      #既存のレコードが新規作成予定のスケジュールの中に入っている場合もエラーを出す
      if (record.start_at < schedule.start_at && schedule.start_at < record.end_at) || (record.start_at < schedule.end_at && schedule.end_at < record.end_at)
        record.errors.add(:start_at, 'か終了時間が既存の予定と重複しています。2')
        break
      end
    end
  end
end
