module Types
  class QueryType < Types::BaseObject
    field :current_user, Types::Objects::UserType, null: true
    def current_user
      context[:current_user]
    end

    field :user, Types::Objects::UserType, null: true do
      argument :id, ID, required: true
    end
    def user(id:)
      Loaders::RecordLoader.for(User).load(id)
    end

    field :users, Types::Objects::UserType.connection_type, null: false
    def users(page: nil, items: nil)
      User.all
    end

    field :blank_schedules, Types::Objects::BlankScheduleType.connection_type, null: false do
      argument :min_date, Types::Scalars::Date, required: true
      argument :max_date, Types::Scalars::Date, required: true
    end
    def blank_schedules(min_date:, max_date:)
      BlankSchedule
        .where(user: current_user)
        .where('end_at >= ? AND start_at <= ?', min_date.beginning_of_day, max_date.end_of_day)
    end
  end
end
