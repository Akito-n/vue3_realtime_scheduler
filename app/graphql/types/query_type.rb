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

    field :blank_schedule, Types::Objects::ScheduleType, null: true do
      argument :blank_schedule_id, ID, required: true, loads: Types::Objects::ScheduleType
    end
    def blank_schedule(blank_schedule:)
      blank_schedule
    end
  end
end
