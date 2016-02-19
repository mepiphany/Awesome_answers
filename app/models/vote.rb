class Vote < ActiveRecord::Base
  belongs_to :user
  belongs_to :question

  validates :question_id, uniqueness: {scope: :user_id}

  # scope :up_count, lamba {where(is_up: true).count}
  # scope :up_count, -> {where(is_up: true).count}


  def self.up_count
    where(is_up: true).count
  end

  def self.down_count
    where(is_up: false).count
  end


end
