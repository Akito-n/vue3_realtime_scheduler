class Subscriptions::CompanyTasks < Subscriptions::BaseSubscription
  #field :blank_schedule_tasks, Types::Objects::OccupationType.connection_type, null: false
  field :has_respond_schedules, Types::Objects::ScheduleType.connection_type, null: false
  field :waiting_schedules, Types::Objects::ScheduleType.connection_type, null: false
  field :confirmed_schedule_tasks, Types::Objects::ScheduleType.connection_type, null: false

  def authorized?(**args)
    context[:current_user].individual?
  end

  def subscribe
    make_results
  end

  def update
    make_results
  end

  private

  def make_results
    #自分からリクエストを送っていないもの # TODO: 仕様決まってない
    ###
    #リクエストが来ている物
    has_respond_schedules = context[:current_user].reseived_schedules.order(created_at: :asc)
    #リクエスト送信済み
    waiting_schedules = context[:current_user].request_schedules.status_pending.order(created_at: :asc)
    #確定済みの予定
    confirmed_schedule_tasks = Schedule.status_accept.where(requester: context[:current_user]).or(Schedule.status_accept.where(responder: context[:current_user])).order(created_at: :asc)

    {
      has_respond_schedules: has_respond_schedules,
      waiting_schedules: waiting_schedules,
      confirmed_schedule_tasks: confirmed_schedule_tasks,
    }
  end
end
