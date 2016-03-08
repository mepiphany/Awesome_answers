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

class Question < ActiveRecord::Base
  attr_accessor :tweet_it

  belongs_to :category
  belongs_to :user




  # This will establish a 'has_many' association with answers. This assumes
  # that your answer model has a 'question_id' integer field that references
  # the question. with has_many 'answers' must be plural (Rails convention).
  #  we must pass a 'dependent' option to maintain data integrity. The possible
  #  values you can give it are: :destroy or :nullify
  #  With :destroy: if you delete a question it will delte all associated answers
  #  With :nullify: if you delete a question it will ipdate the 'question_id' null
  #                 for all associated records (they won't get deleted)
  has_many :answers, dependent: :destroy
  # this enables us to access all the comments created for all the question's
  # answers. This generates a single SQL statment with 'INNER JOIN' to
  # accomplish it
  has_many :comments, through: :answers

  has_many :likes, dependent: :destroy
  has_many :users, through: :likes

  has_many :favorites, dependent: :destroy
  has_many :favor_users, through: :favorites, source: :user

  has_many :taggings, dependent: :destroy
  has_many :tags, through: :taggings

  has_many :votes, dependent: :destroy
  has_many :voting_users, through: :votes, source: :user




  #first form of validation
  # This will fail validations (so it won't create or save) if the title is
  # not provided
    validates :title, presence: true,
                      uniqueness: { case_sensitive: false},
                      length: {minimum: 3, maximum: 255}
    #how to change default message
    # DSL: Domain Specific Langugage
    # the code we use in here is completely valid Ruby code but the method naming
    # and arguments are specific to AvtiveRecord so we call this an AvtiveRecord
    # DSL
    validates(:body, {uniqueness: {message: "must be unique!"}})

    # this validates that the combination of the title and body is unique. Which
    # means the title doesn't have to be unique by itself and the body doesn't
    # have to be unique by itself. However, the combination of the two fields
    # must be unique
    # validates :title, uniqueness: {scope: :body}

    validates :view_count, numericality: {greater_than_or_equal_to: 0}

    #   validates :email,
    #             format: { with: /\A([\w+\-]\.?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i }

    # this is using custom validation method, we must make sure that "no_monkey"
    # is a method available for our class. the method can be public or private
    # It's more likely we will have it a private method because we don't need
    # to use it outside this class.
    validate :no_monkey

    after_initialize :set_defaults
    before_save :capitalize_title

    # without an arguments scope :recent, lambda { order("created_at DESC").limit(5)}
    # with an arguments scope :recent, lambda { |x| order("created_at DESC").limit(x)}
    # you are able to combine query
    # you are able to give arguments to give you more flexibility
    def self.recent(number = 5)
      order("created_at DESC").limit(number)

    end

    def self.popular
      where("view_count > 10")
    end

    # Wildcard search by title or body
    # ordered by view_count in a descending order
    def self.search(term)
      # where(["title ILIKE ? or body ILIKE ?", "%#{term}%", "%#{term}%"])

      where(["title ILIKE ? or body ILIKE ?", "%" + term + "%", "%" + term + "%"]).
      order("view_count DESC").limit(10)

    end
    def category_name
      category.name if category
    end
    # delegate :full_name, to: :user, prefix: true <--------- this is a short to
    # acheiveing the same goal as below.
    def user_full_name
      user.full_name if user
    end

    def like_for(user)
      likes.find_by_user_id user
    end

    def favor_for(user)
      favorites.find_by_user_id user
    end

    def vote_for(user)
      votes.find_by_user_id user
    end

    def vote_result
      votes.up_count - votes.down_count
    end







    private
    def set_defaults
      self.view_count ||= 0
                      #(conditional operator, if it's not set use 0 )
    end

    # capitalize_title method is done after validation,
    # therefore, you don't need to worry about nil
    def capitalize_title
      self.title.capitalize!
    end


  def no_monkey
    if title && title.downcase.include?("monkey")
# errors method take two arguments first one is field, and what you want to print out
      errors.add(:title,"false")
    end
  end
end
