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

require 'test_helper'

class CaseTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
