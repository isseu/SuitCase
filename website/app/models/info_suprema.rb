# == Schema Information
#
# Table name: info_supremas
#
#  id              :integer          not null, primary key
#  case_id         :integer
#  numero_ingreso  :string
#  tipo_recurso    :string
#  ubicacion       :string
#  corte           :string
#  fecha_ubicacion :date
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class InfoSuprema < ActiveRecord::Base
  belongs_to :case
  has_many :cases, as: :info
end
