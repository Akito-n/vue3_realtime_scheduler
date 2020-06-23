class Mutations::RequestSchedule < Mutations::BaseMutation
  null true

  argument :blank_schedule_id, ID, required: true, loads: Types::Objects::BlankScheduleType
  argument :start_at, Types::Scalars::DateTime, required: true
  argument :end_at, Types::Scalars::DateTime, required: true

  field :schedule, Types::Objects::ScheduleType, null: true
  #field :user, Types::Objects::UserType, null: true

  def authorized?(blank_schedule:, **args)
    context[:user_signed_in]
  end

  def resolve(blank_schedule:, start_at:, end_at:, **args)
    user = context[:current_user]
    schedule = user.request_schedules.build(start_at: start_at, end_at: end_at, responder: blank_schedule.user)
    if schedule.save
      AppSchema.subscriptions.trigger('schedules', {}, {})
      {
        schedule: schedule
      }
    else
      set_errors(schedule)
      return
    end
  end

  def set_errors(schedule)
    message = schedule.errors.full_messages.join(', ')
    context.add_error(GraphQL::ExecutionError.new(message))
  end
end
