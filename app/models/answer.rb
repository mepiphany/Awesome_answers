# == Schema Information
#
# Table name: answers
#
#  id          :integer          not null, primary key
#  body        :text
#  question_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :user
  has_many :comments, dependent: :destroy

  # Adding uniqueness: { scope: :question_id } will make sure that an answer's
  # body is unique for a given question. this means you can't submit the same
  # answer body twice for the same question but you can submit the same answer
  # body for two different quedstions.
  validates :body, presence: true, uniqueness: { scope: :question_id }

end
