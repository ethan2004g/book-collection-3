require 'rails_helper'

RSpec.describe Book, type: :model do
  describe 'validations' do
    subject(:book) { Book.new(title: 'Test Book', author: 'Test Author', price: 19.99, published_date: Date.today) }

    it 'is valid with all required attributes' do
      expect(book).to be_valid
    end

    it 'requires a title' do
      book.title = nil
      expect(book).not_to be_valid
      expect(book.errors[:title]).to include("can't be blank")
    end

    it 'requires an author' do
      book.author = nil
      expect(book).not_to be_valid
      expect(book.errors[:author]).to include("can't be blank")
    end

    it 'requires a price' do
      book.price = nil
      expect(book).not_to be_valid
      expect(book.errors[:price]).to include("can't be blank")
    end

    it 'requires a published_date' do
      book.published_date = nil
      expect(book).not_to be_valid
      expect(book.errors[:published_date]).to include("can't be blank")
    end

    it 'requires price to be non-negative' do
      book.price = -10
      expect(book).not_to be_valid
      expect(book.errors[:price]).to include("must be greater than or equal to 0")
    end

    it 'requires title to be unique' do
      existing_book = Book.create!(title: 'Test Book', author: 'Another Author', price: 29.99, published_date: Date.today)
      expect(book).not_to be_valid
      expect(book.errors[:title]).to include("has already been taken")
    end
  end
end