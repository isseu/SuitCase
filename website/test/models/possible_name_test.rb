# == Schema Information
#
# Table name: possible_names
#
#  id              :integer          not null, primary key
#  user_id         :integer
#  name            :string
#  first_lastname  :string
#  second_lastname :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require 'test_helper'

class PossibleNameTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
