class BooksController < ApplicationController
  before_action :set_book, only: [:show, :edit, :update, :destroy]
  before_action :check_permissions, only: [:edit, :update, :destroy]

  # GET /books
  # GET /books.json
  def index
    @books = Book.all
  end

  # GET /books/1
  # GET /books/1.json
  def show
  end

  def epub_reader
    @reading_book = Book.find(params[:id]).book_file
  end

  # GET /books/new
  def new
    @book = Book.new
  end

  # GET /books/1/edit
  def edit
  end

  # POST /books
  # POST /books.json
  def create
    @book = Book.new(book_params)
    respond_to do |format|
      if @book.save
        format.js {render js: "window.location='#{book_path(@book)}'"}
        format.json { render :show, status: :created, location: @book }
      else
        format.js {  }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /books/1
  # PATCH/PUT /books/1.json
  def update
    respond_to do |format|
      if @book.update(book_params)
        format.html { redirect_to @book, notice: 'Book was successfully updated.' }
        format.json { render :show, status: :ok, location: @book }
      else
        format.html { render :edit }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /books/1
  # DELETE /books/1.json
  def destroy
    @book.destroy
    respond_to do |format|
      format.html { redirect_to books_url, notice: 'Book was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_book
      @book = Book.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def book_params
      params.require(:book).permit(
        :title, :date_of_publication, :annotation, :volume, :language, :cover, :cover_cache, :book_file, :book_file_cache, author_ids: [], publisher_ids: [], genre_ids: [],
        authors_attributes: [:id, :first_name, :last_name, :second_name, :biography, :gender, :photo, :_destroy],
        publishers_attributes: [:id, :publisher_name, :publisher_logo, :publisher_logo, :publisher_location, :_destroy],
      )
    end

    def check_permissions
      unless (@book.readers.exists?(id: current_reader.id) || current_reader.admin?)
        redirect_to root_url, notice: "You can't edit other's book"
      end
    end
end
