class Mutations::DestroyBlankSchedule < Mutations::BaseMutation
  null true

  argument :blank_schedule_id, ID, required: true, loads: Types::Objects::ScheduleType

  field :blank_schedule, Types::Objects::ScheduleType, null: true
  #field :user, Types::Objects::UserType, null: true

  def authorized?(blank_schedule:, **args)
    context[:user_signed_in] && blank_schedule.can_write?(context[:current_user])
  end

  def resolve(blank_schedule:)
    if blank_schedule.destroy
      subscription_trigger
      {
        blank_schedule: nil
      }
    else
      set_errors(blank_schedule)
      return
    end
  end

  def set_errors(blank_schedule)
    message = blank_schedule.errors.full_messages.join(', ')
    context.add_error(GraphQL::ExecutionError.new(message))
  end
end
