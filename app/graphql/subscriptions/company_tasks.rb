class Subscriptions::CompanyTasks < Subscriptions::BaseSubscription
  #field :blank_schedule_tasks, Types::Objects::OccupationType.connection_type, null: false
  field :has_respond_schedules, Types::Objects::ScheduleType.connection_type, null: false
  field :waiting_schedules, Types::Objects::ScheduleType.connection_type, null: false
  field :confirmed_schedule_tasks, Types::Objects::ScheduleType.connection_type, null: false

  def authorized?(**args)
    context[:current_user].company?
  end

  def subscribe
    make_results
  end

  def update
    make_results
  end

  private

  def make_results
    # 自分の案件に応募してきた個人の一覧
    entry_users = User.individual.joins(:entries).select('users.*, recruitements.occupation_id').where(recruitements: {company_user_id: context[:current_user].id})
    #自分からリクエストを送っていない,かつ相手からもリクエストがきていない、宙ぶらりんの状態のユーザー
      nonactive_users = entry_users.map {|user|
        user if Schedule.where('occupation_id = ? and  requester_id = ? or responder_id = ?', user.occupation_id, user.id, user.id).empty?
      }.compact
    #自分のスケジュール
    schedules = Schedule.status_pending.where(requester: context[:current_user].occupations).or(Schedule.status_pending.where(responder: context[:current_user].occupations)).order(created_at: :asc)
    #リクエストが来ている物
    has_respond_schedules = Schedule.status_pending.where(responder: context[:current_user].occupations).order(created_at: :asc)
    # #リクエスト送信済みn
    waiting_schedules = Schedule.status_pending.where(requester: context[:current_user].occupations).order(created_at: :asc)
    # #確定済みの予定
    confirmed_schedule_tasks = Schedule.status_accept.where(requester: context[:current_user]).or(Schedule.status_accept.where(responder: context[:current_user])).order(created_at: :asc)

    {
      has_respond_schedules: has_respond_schedules,
      waiting_schedules: waiting_schedules,
      confirmed_schedule_tasks: confirmed_schedule_tasks,
    }
  end
end
