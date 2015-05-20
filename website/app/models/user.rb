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
#  avatar_file_name       :string
#  avatar_content_type    :string
#  avatar_file_size       :integer
#  avatar_updated_at      :datetime
#

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :recoverable,
         :rememberable, :trackable, :validatable #, registerable

  # Avatar - Paperclip
  has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "default-avatar.png"
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/

  validates :rut, rut: { message: 'no es valido'}
  validates :role, presence: true

  has_many :possible_names, dependent: :destroy
  has_many :notifications, dependent: :destroy
  has_many :client_users, dependent: :destroy
  has_many :clients, through: :client_users
  has_many :case_users, dependent: :destroy
  has_many :cases, through: :case_users
  has_many :case_records, dependent: :destroy
  has_many :recorded_cases, through: :case_records, class_name: Case

  # Posibles roles de cada usuario
  ROLES = %w[guest secretary lawyer admin]
  FROLES = { 'guest' => 'Invitado', 'secretary' => 'Secretaria', 'lawyer' => 'Abogado', 'admin' => 'Administrador' }

  def role?(base_role)
    ROLES.index(base_role.to_s) == ROLES.index(self.role)
  end

  def inspect
    self.name.titleize + ' ' + self.first_lastname.titleize + ' ' + self.second_lastname
  end

  def format_role
    return (FROLES.key?(self.role)) ? FROLES[self.role] : self.role
  end

  def following_case?(id)
    return self.case_users.where(case_id: id).empty? == false
  end

  def recording_case?(id)
    return self.case_records.where(case_id: id).empty? == false
  end

end
