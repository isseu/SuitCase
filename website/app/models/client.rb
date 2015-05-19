# == Schema Information
#
# Table name: clients
#
#  id              :integer          not null, primary key
#  name            :string           not null
#  rut             :string
#  first_lastname  :string
#  second_lastname :string
#  is_company      :boolean          default("false")
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Client < ActiveRecord::Base
  has_many :client_users
  has_many :users, through: :client_users

  # Si es compañia, valido rut?
  # validates :rut, rut: { message: 'no es valido'}
  validates :name, presence: true
end
