class Mutations::AddBlankSchedule < Mutations::BaseMutation
  null true

  argument :start_at, Types::Scalars::DateTime, required: true
  argument :end_at, Types::Scalars::DateTime, required: true

  field :blank_schdule, Types::Objects::BlankScheduleType, null: true
  #field :user, Types::Objects::UserType, null: true

  def authorized?(**args)
    context[:user_signed_in]
  end

  def resolve(start_at:, end_at:)
    schedule = BlankSchedule.create(start_at: start_at, end_at: end_at, user: context[:current_user])
    { blank_schdule: schedule }
  end
end
