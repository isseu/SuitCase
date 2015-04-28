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

require 'test_helper'

class LitiganteTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
