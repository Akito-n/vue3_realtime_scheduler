class Subscriptions::CompanySchedules < Subscriptions::BaseSubscription
  argument :occupation_ids, [ID], required: true, loads: Types::Objects::OccupationType
  argument :user_ids, [ID], required: true, loads: Types::Objects::MemberType

  field :schedules, Types::Objects::ScheduleType.connection_type, null: false

  def authorized?(**args)
    context[:current_user].company?
  end

  def subscribe(occupations:, users:)
    if occupations.present? || users.present?
      if occupations.present? && users.present?
        entry_users = User.where(entries: Recruitement.joins(:individual_user).where(occupation: occupations)).where(id: users)
        schedules = Schedule.where(requester: users, responder: occupations).or(Schedule.where(requester: occupations, responder: users)).to_a
      elsif users.present?
        entry_users = users
        schedules = Schedule.where(requester: users, responder: context[:current_user].occupations).or(Schedule.where(requester: context[:current_user].occupations, responder: users)).to_a
      elsif occupations.present?
        entry_users = User.where(entries: Recruitement.joins(:individual_user).where(occupation: occupations))
        schedules = Schedule.where(requester: entry_users, responder: context[:current_user].occupations).or(Schedule.where(requester: context[:current_user].occupations, responder: entry_users)).to_a
      end
      blank_schedules = BlankSchedule.where(schedulable: entry_users).to_a
      return {
        schedules: blank_schedules + schedules
      }
    end

    make_results
  end

  def update(occupations:, users:)
    make_results
  end

  private

  def make_results
    user = context[:current_user]
    # 面接予定がfixしていないリクルートメントに紐づく案件の一覧
    filtered_occupations = user.unsettled_individual_occupations.reload.to_a # TODO: ここでフラグによっては全部のoccupationをとってくる
    # 面接予定ががfixしていないものがあるユーザーの一覧
    filtered_individual_users = user.unsettled_individual_users.reload.to_a # TODO: ここでフラグによっては全部のindividual_userをとってくる
    # 空き予定は法人の登録した空き予定か、フィルタリング済みのユーザーの空き予定
    blank_schedules = BlankSchedule.where(schedulable: user.occupations + filtered_individual_users).to_a
    #スケジュールは自分の全ての案件に紐づくスケジュール
    schedules = Schedule.where(requester: user.occupations).or(Schedule.where(responder: user.occupations)).to_a
    {
      schedules: blank_schedules + schedules
    }
  end
end
