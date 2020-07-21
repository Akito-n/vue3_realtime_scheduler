class Subscriptions::IndividualTasks < Subscriptions::BaseSubscription
  field :blank_schedule_tasks, Types::Objects::OccupationType.connection_type, null: false
  field :waiting_tasks, Types::Objects::ScheduleType.connection_type, null: false
  field :responding_tasks, Types::Objects::ScheduleType.connection_type, null: false
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
    occupations = context[:current_user].company_occupations
    has_blank_schedule_task = context[:current_user].blank_schedules.exists?(start_at: Time.current..Float::INFINITY)
    waiting_tasks = context[:current_user].request_schedules.status_pending.order(created_at: :asc)
    responding_tasks = context[:current_user].reseived_schedules.status_pending.order(created_at: :asc)
    confirmed_schedule_tasks = Schedule.where(status: :accept).where(requester: context[:current_user]).or(Schedule.where(status: :accept).where(responder: context[:current_user])).order(created_at: :asc)

    {
      blank_schedule_tasks: has_blank_schedule_task ? [] : occupations, # TODO: 確定済の案件どうする?
      waiting_tasks: waiting_tasks,
      responding_tasks: responding_tasks,
      confirmed_schedule_tasks: confirmed_schedule_tasks,
    }
  end
end
