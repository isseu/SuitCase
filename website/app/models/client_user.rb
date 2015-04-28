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

class ClientUser < ActiveRecord::Base
  belongs_to :user
  belongs_to :client
end
