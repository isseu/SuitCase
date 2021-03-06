# == Schema Information
#
# Table name: case_records
#
#  id         :integer          not null, primary key
#  case_id    :integer
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class CaseRecord < ActiveRecord::Base
  belongs_to :case
  belongs_to :user

  validates :case_id, uniqueness: {scope: :user_id}

end
