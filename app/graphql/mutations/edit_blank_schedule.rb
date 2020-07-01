class Mutations::EditBlankSchedule < Mutations::BaseMutation
  null true

  argument :blank_schedule_id, ID, required: true, loads: Types::Objects::ScheduleType
  argument :start_at, Types::Scalars::DateTime, required: false
  argument :end_at, Types::Scalars::DateTime, required: false
  argument :occupation_id, ID, required: false

  field :blank_schedule, Types::Objects::ScheduleType, null: true

  def authorized?(blank_schedule:, **args)
    context[:user_signed_in] && blank_schedule.can_write?(context[:current_user])
  end

  def resolve(blank_schedule:, occupation_id: nil, **input)
    occupation = occupation_id.present? ? AppSchema.object_from_id(occupation_id, context) : nil
    if blank_schedule.update(input.merge(schedulable: occupation).compact)
      AppSchema.subscriptions.trigger('schedules', {}, {})
      {
        blank_schedule: blank_schedule
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
