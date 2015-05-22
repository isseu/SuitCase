# == Schema Information
#
# Table name: receptors
#
#  id            :integer          not null, primary key
#  info_civil_id :integer
#  notebook      :string
#  dat           :string
#  state         :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require 'test_helper'

class ReceptorTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
