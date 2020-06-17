class Mutations::RequestSchedule < Mutations::BaseMutation
  null true

  argument :blank_schedule_id, ID, required: true, loads: Types::Objects::BlankScheduleType

  field :schedule, Types::Objects::ScheduleType, null: true
  #field :user, Types::Objects::UserType, null: true

  def authorized?(blank_schedule:, **args)
    context[:user_signed_in]
  end

  def resolve(blank_schedule:, **args)
    user = context[:current_user]
    schedule = user.request_schedules.build(start_at: blank_schedule.start_at, end_at: blank_schedule.end_at, responder: blank_schedule.user)
    if schedule.save
      AppSchema.subscriptions.trigger('blankSchedules', {}, {})
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
