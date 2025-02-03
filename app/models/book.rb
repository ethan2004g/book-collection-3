class Book < ApplicationRecord
    has_many :users, through: :user_books
    has_many :user_books

    validates :title, presence: true, uniqueness: true
    validates :author, presence: true
    validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
    validates :published_date, presence: true
  end