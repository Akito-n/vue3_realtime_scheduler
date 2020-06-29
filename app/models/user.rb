# == Schema Information
#
# Table name: users
#
#  id                     :uuid             not null, primary key
#  color                  :string           default("purple"), not null
#  company_name           :string
#  confirmation_sent_at   :datetime
#  confirmation_token     :string
#  confirmed_at           :datetime
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :inet
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :inet
#  name                   :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  role                   :integer          default("individual"), not null
#  sign_in_count          :integer          default(0), not null
#  unconfirmed_email      :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :trackable

  enum role: { individual: 0, company: 1, admin: 9 }

  has_many :blank_schedules, as: :schedulable
  has_many :occupations
  #法人からみる応募
  has_many :recruitements, foreign_key: :company_user_id
  has_many :individual_users, through: :recruitements, source: :individual_user
  #個人からのアクション
  has_many :entries, foreign_key: :individual_user_id, class_name: :Recruitement
  has_many :company_users, through: :entries, source: :company_user
  #個人から応募した会社の案件
  has_many :company_occupations, through: :entries, source: :occupation

  has_many :request_schedules, class_name: :Schedule, as: :requester
  has_many :reseived_schedules, class_name: :Schedule, as: :responder

  #FIXME 名前
  def schedulable_array
    targets = individual? ? company_occupations : individual_users
    my_schedules = my_schedulable_array
    [my_schedules, targets.to_a].flatten.sort{|x| x.created_at}
  end

  #FIXME 名前
  def my_schedulable_array
    individual? ? self : occupations
  end
end
