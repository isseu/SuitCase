# == Schema Information
#
# Table name: receptors
#
#  id            :integer          not null, primary key
#  info_civil_id :integer
#  notebook      :string
#  dat           :string
#  state         :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Receptor < ActiveRecord::Base
  belongs_to :info_civil
end
