# == Schema Information
#
# Table name: info_civils
#
#  id         :integer          not null, primary key
#  case_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class InfoCivil < ActiveRecord::Base
  belongs_to :case
end
