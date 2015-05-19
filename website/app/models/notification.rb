# == Schema Information
#
# Table name: notifications
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  text       :text
#  read       :boolean
#  url        :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Notification < ActiveRecord::Base
  belongs_to :user

  def self.get_all_unread(user)
    return Notification.all.where(user_id: user.id, read: false)
  end

end
