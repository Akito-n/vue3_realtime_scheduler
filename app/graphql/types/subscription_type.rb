module Types
  class SubscriptionType < Types::BaseObject
    extend GraphQL::Subscriptions::SubscriptionRoot
    field :individual_schedules, subscription: Subscriptions::IndividualSchedules
    field :individual_tasks, subscription: Subscriptions::IndividualTasks

    field :company_schedules, subscription: Subscriptions::CompanySchedules
    field :company_tasks, subscription: Subscriptions::CompanyTasks
  end
end
