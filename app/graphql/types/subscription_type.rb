module Types
  class SubscriptionType < Types::BaseObject
    extend GraphQL::Subscriptions::SubscriptionRoot
    field :blank_schedules, subscription: Subscriptions::BlankSchedules
  end
end
