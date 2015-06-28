# == Schema Information
#
# Table name: cases
#
#  id         :integer          not null, primary key
#  rol        :string
#  fecha      :datetime
#  tribunal   :string
#  caratula   :text
#  info_id    :integer
#  info_type  :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Case < ActiveRecord::Base
  has_many :case_users, dependent: :destroy
  has_many :users, through: :case_users
  has_many :case_records, dependent: :destroy
  has_many :recording_users, through: :case_records, class_name: User
  has_many :litigantes, dependent: :destroy
  belongs_to :info, polymorphic: true
  before_save :to_titleize

  def to_titleize
    self.caratula = self.caratula.titleize
    self.save
  end
end
