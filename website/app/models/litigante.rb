# == Schema Information
#
# Table name: litigantes
#
#  id           :integer          not null, primary key
#  case_id      :integer
#  participante :string
#  rut          :string
#  persona      :string
#  nombre       :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Litigante < ActiveRecord::Base
  belongs_to :case

  before_save :to_titleize

  def to_titleize
    self.nombre = self.nombre.titleize
  end
end
