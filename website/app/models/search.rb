# == Schema Information
#
# Table name: searches
#
#  id              :integer          not null, primary key
#  name            :string
#  first_lastname  :string
#  second_lastname :string
#  rut             :string
#  rol             :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  state           :boolean          default("false")
#

class Search < ActiveRecord::Base
  def set_ready
    self.state = true
    self.save
  end
end
