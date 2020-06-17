class Subscriptions::BlankSchedules < Subscriptions::BaseSubscription
  #argument :question_id, ID, required: true, loads: Types::QueryType

  field :blank_schedules, Types::Objects::BlankScheduleType.connection_type, null: false

  # def authorized?(**args)
  #   true
  # end

  def subscribe
    # TODO: 期間指定も必要
    {
      blank_schedules: BlankSchedule.where(user: context[:current_user].members_array)
    }
  end

  def update
    {
      blank_schedules: BlankSchedule.where(user: context[:current_user].members_array).reload
    }
  end
end
