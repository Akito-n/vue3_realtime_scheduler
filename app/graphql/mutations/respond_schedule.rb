class Mutations::RespondSchedule < Mutations::BaseMutation
  null false

  argument :schedule_id, ID, required: true, loads: Types::Objects::ScheduleType

  field :schedule, Types::Objects::ScheduleType, null: true

  def authorized?(schedule:, **args)
    context[:user_signed_in] && schedule.responder == context[:current_user]
  end

  def resolve(schedule:, **args)
    user = context[:current_user]
    if schedule.update(accepted_at: Time.zone.now)
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
