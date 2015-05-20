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

class PossibleName < ActiveRecord::Base
  belongs_to :user
  validates :user_id, presence: true
end
