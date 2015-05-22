# == Schema Information
#
# Table name: info_cortes
#
#  id              :integer          not null, primary key
#  case_id         :integer
#  numero_ingreso  :string
#  ubicacion       :string
#  corte           :string
#  fecha_ubicacion :date
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class InfoCorte < ActiveRecord::Base
  belongs_to :case
end
