# == Schema Information
#
# Table name: questions
#
#  id         :integer          not null, primary key
#  title      :string
#  body       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  view_count :integer
#

require 'test_helper'

class QuestionsControllerTest < ActionController::TestCase
  # test "the truth" do
  #   assert true
  # end
end
