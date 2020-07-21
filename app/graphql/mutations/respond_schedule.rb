class Mutations::RespondSchedule < Mutations::BaseMutation
  null false

  argument :schedule_id, ID, required: true, loads: Types::Objects::ScheduleType
  argument :is_accept, Boolean, required: false


  field :schedule, Types::Objects::ScheduleType, null: true

  def authorized?(schedule:, **args)
    context[:user_signed_in] && schedule.can_response?(context[:current_user])
  end

  def resolve(schedule:, is_accept: true, **args)
    user = context[:current_user]
    ActiveRecord::Base.transaction do
      is_accept ? schedule.accept! : schedule.reject!
      subscription_trigger
      {
        schedule: schedule
      }
    end
  end

  def set_errors(schedule)
    message = schedule.errors.full_messages.join(', ')
    context.add_error(GraphQL::ExecutionError.new(message))
  end
end
