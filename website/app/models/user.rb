# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default("0"), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  created_at             :datetime
#  updated_at             :datetime
#  role                   :string
#  rut                    :string           default(""), not null
#  name                   :string           default(""), not null
#  first_lastname         :string           default(""), not null
#  second_lastname        :string           default(""), not null
#  password_judicial      :string
#  telephone              :string
#

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :recoverable,
         :rememberable, :trackable, :validatable #, registerable
  validates :rut, rut: { message: 'no es valido'}

  has_many :possible_names
  has_many :notifications
  has_many :client_users
  has_many :clients, through: :client_users
  has_many :case_users
  has_many :cases, through: :case_users
  has_many :case_records
  has_many :recorded_cases, through: :case_records, class_name: Case

  # Posibles roles de cada usuario
  ROLES = %w[guest secretary lawyer admin]

  def role?(base_role)
    ROLES.index(base_role.to_s) == ROLES.index(self.role)
  end

  def inspect
    self.name.titleize + ' ' + self.first_lastname.titleize + ' ' + self.second_lastname
  end
end
