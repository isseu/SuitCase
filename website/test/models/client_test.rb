# == Schema Information
#
# Table name: clients
#
#  id              :integer          not null, primary key
#  name            :string           not null
#  rut             :string
#  first_lastname  :string
#  second_lastname :string
#  is_company      :boolean          default("f")
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require 'test_helper'

class ClientTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
