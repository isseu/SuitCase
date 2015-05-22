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

require 'test_helper'

class InfoSupremaTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
