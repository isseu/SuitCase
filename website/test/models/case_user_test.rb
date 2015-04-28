# == Schema Information
#
# Table name: case_users
#
#  id         :integer          not null, primary key
#  case_id    :integer
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'test_helper'

class CaseUserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
