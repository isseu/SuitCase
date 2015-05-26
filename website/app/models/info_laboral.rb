# == Schema Information
#
# Table name: info_laborals
#
#  id         :integer          not null, primary key
#  case_id    :integer
#  rit        :string
#  ruc        :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class InfoLaboral < ActiveRecord::Base
  belongs_to :case
  has_many :cases, as: :info
end
