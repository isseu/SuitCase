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

  validates :case_id, uniqueness: {scope: :user_id}
  before_destroy :destroy_case_record

  def destroy_case_record
    case_record = self.case.case_records.where(user_id: self.user.id).first
    case_record.destroy if case_record
    true
  end

end
