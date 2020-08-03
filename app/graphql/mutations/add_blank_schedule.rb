class Mutations::AddBlankSchedule < Mutations::BaseMutation
  null true

  argument :start_at, Types::Scalars::DateTime, required: true
  argument :end_at, Types::Scalars::DateTime, required: true
  argument :occupation_id, ID, required: false

  field :blank_schedules, [Types::Objects::ScheduleType], null: true
  #field :user, Types::Objects::UserType, null: true

  def authorized?(**args)
    context[:user_signed_in]
  end

  def resolve(start_at:, end_at:, occupation_id: nil)
    user = context[:current_user]
    if user.individual?
      schedulable = user
    else
      schedulable = AppSchema.object_from_id(occupation_id, context)
    end

    ActiveRecord::Base.transaction do
      blank_schedules = BlankSchedule.create_from_range!(schedulable: schedulable, start_at: start_at, end_at: end_at)

      subscription_trigger
      {
        blank_schedules: blank_schedules
      }
    end
  rescue => e
    message = e.record.errors.full_messages.join(', ')
    context.add_error(GraphQL::ExecutionError.new(message))
  end
end
