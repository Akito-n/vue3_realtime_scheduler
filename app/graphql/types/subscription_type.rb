module Types
  class SubscriptionType < Types::BaseObject
    extend GraphQL::Subscriptions::SubscriptionRoot
    field :schedules, subscription: Subscriptions::Schedules
    field :individual_tasks, subscription: Subscriptions::IndividualTasks
    field :company_tasks, subscription: Subscriptions::CompanyTasks
  end
end
