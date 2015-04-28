# == Schema Information
#
# Table name: client_users
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  client_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'test_helper'

class ClientUserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
