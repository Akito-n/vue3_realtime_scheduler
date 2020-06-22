module Types
  class SubscriptionType < Types::BaseObject
    extend GraphQL::Subscriptions::SubscriptionRoot
    field :schedules, subscription: Subscriptions::Schedules
  end
end
