class BooksController < ApplicationController
  before_action :set_book, only: [:show, :edit, :update, :destroy]
  before_action :validate_book_params, only: [:create, :update]

  def index
    @books = Book.all
  rescue => e
    flash[:notice] = "Error in retrieving books, please check database connection"
  end

  def show
    @book = Book.find_by(title: params[:title])
    if @book
      @urltitle = URI.encode_www_form_component(@book.title)
    else
      flash[:notice] = "Error in retrieving book, please try again"
      redirect_to root_path
    end
  rescue => e
    flash[:notice] = "Error in retrieving book, please try again"
    redirect_to root_path
  end

  def new
    @book = Book.new
  end

  def create
    @book = Book.new(book_params)
    
    # Check for duplicate title
    if Book.exists?(title: @book.title)
      flash[:notice] = "Error: Book title already exists"
      render :new
      return
    end

    if @book.save
      flash[:notice] = "Created Book: #{@book.title}"
      redirect_to root_path
    else
      flash[:notice] = "Error: Invalid Entry"
      render :new
    end
  end

  def edit
    @urltitle = URI.encode_www_form_component(@book.title)
  end

  def update
    # Check for validation errors 
    if @validation_errors.present?
      flash[:notice] = "Error: #{@validation_errors.join(', ')}"
      render :edit
      return
    end

    if @book.update(book_params)
      flash[:notice] = "Edited book: #{@book.title}"
      redirect_to root_path
    else
      render :edit
    end
  end

  def delete
    @book = Book.find_by(title: params[:title])
    redirect_to root_path, notice: 'Book not found.' unless @book
  end

  def destroy
    title = URI.decode_www_form_component(params[:title])
    if @book
      @book.destroy
      flash[:notice] = "Removed book: #{title}"
      redirect_to root_path
    else
      flash[:notice] = "Error in deleting book, please try again"
      redirect_to root_path
    end
  end

  private

  def set_book
    @book = Book.find_by(title: params[:title])
    redirect_to root_path, notice: 'Book not found.' unless @book
  end

  def book_params
    params.require(:book).permit(:title, :author, :price, :published_date)
  end

  def validate_book_params
    @validation_errors = []
    params = book_params

    # Validate presence of required fields
    @validation_errors << "Title is required" if params[:title].blank?
    @validation_errors << "Author is required" if params[:author].blank?
    

    if params[:price].present?
      begin
        price = BigDecimal(params[:price].to_s)
        @validation_errors << "Price must be greater than or equal to 0" if price.negative?
      rescue ArgumentError
        @validation_errors << "Price must be a valid number"
      end
    end


    if params[:published_date].present?
      begin
        Date.parse(params[:published_date].to_s)
      rescue ArgumentError
        @validation_errors << "Published date must be a valid date"
      end
    end
  end
end