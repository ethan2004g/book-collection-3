require 'rails_helper'

RSpec.describe BooksController, type: :controller do
  let(:valid_attributes) {
    {
      title: 'The Great Gatsby',
      author: 'F. Scott Fitzgerald',
      price: 19.99,
      published_date: '2022-01-01'
    }
  }

  let(:invalid_attributes) {
    {
      title: '',
      author: '',
      price: nil,
      published_date: ''
    }
  }

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'creates a new book and sets success flash notice' do
        expect {post :create, params: { book: valid_attributes }}.to change(Book, :count).by(1)
        expect(flash[:notice]).to eq("Created Book: #{valid_attributes[:title]}")
        expect(response).to redirect_to(root_path)
      end

      it 'creates a book with all attributes properly set' do
        post :create, params: { book: valid_attributes }
        book = Book.last
        
        expect(book.title).to eq(valid_attributes[:title])
        expect(book.author).to eq(valid_attributes[:author])
        expect(book.price).to eq(valid_attributes[:price])
        expect(book.published_date.to_s).to eq(valid_attributes[:published_date])
      end
    end

    context 'with invalid attributes' do
      it 'does not create a book with blank title' do
        expect {post :create, params: { book: invalid_attributes }}.not_to change(Book, :count)
        expect(flash[:notice]).to eq("Error: Invalid Entry")
        expect(response).to render_template(:new)
      end

      it 'does not create a book with duplicate title' do
        Book.create!(valid_attributes)
        expect {post :create, params: { book: valid_attributes }}.not_to change(Book, :count)
        expect(flash[:notice]).to eq("Error: Book title already exists")
        expect(response).to render_template(:new)
      end

      it 'does not create a book with invalid price' do
        expect {post :create, params: { book: valid_attributes.merge(price: -10) }}.not_to change(Book, :count)
      end

      it 'does not create a book with invalid date format' do
        expect {post :create, params: { book: valid_attributes.merge(published_date: 'invalid-date') }}.not_to change(Book, :count)
      end
    end
  end

  describe 'PUT #update' do
    let!(:book) { Book.create!(valid_attributes) }

    it 'updates the book with new attributes' do
      new_attributes = {title: 'Updated Title',author: 'Updated Author',price: 29.99,published_date: '2023-01-01'}

      put :update, params: { title: book.title, book: new_attributes }
      book.reload

      expect(book.title).to eq(new_attributes[:title])
      expect(book.author).to eq(new_attributes[:author])
      expect(book.price).to eq(new_attributes[:price])
      expect(book.published_date.to_s).to eq(new_attributes[:published_date])
      expect(flash[:notice]).to eq("Edited book: #{new_attributes[:title]}")
      expect(response).to redirect_to(root_path)
    end
  end

  describe 'DELETE #destroy' do
    let!(:book) { Book.create!(valid_attributes) }
    it 'deletes the book and sets success flash notice' do
      expect {delete :destroy, params: { title: book.title }}.to change(Book, :count).by(-1)
      expect(flash[:notice]).to eq("Removed book: #{book.title}")
      expect(response).to redirect_to(root_path)
    end

    
  end
end