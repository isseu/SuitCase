# == Schema Information
#
# Table name: clients
#
#  id              :integer          not null, primary key
#  name            :string           not null
#  rut             :string
#  first_lastname  :string
#  second_lastname :string
#  is_company      :boolean          default("f")
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Client < ActiveRecord::Base
  validates :rut, rut: { message: 'no es valido'}
  has_many :client_users
  has_many :users, through: :client_users
end
