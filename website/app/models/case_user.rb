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

class CaseUser < ActiveRecord::Base
  belongs_to :case
  belongs_to :user
end
