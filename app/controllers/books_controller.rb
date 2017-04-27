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
    @query = Array.new
    parsed_book = EPUB::Parser.parse(@book.book_file.path)
    (parsed_title = parsed_book.metadata.title).blank? ? @query<<"title" : @book.update_attributes(title: parsed_title)
    (parsed_annotation = ActionView::Base.full_sanitizer.sanitize(parsed_book.metadata.description)).blank? ? @query<<"annotation" : @book.update_attributes(annotation: parsed_annotation)
    (opened_file = cover_image(parsed_book)).blank? || (parsed_cover = File.open(opened_file, 'r')).blank? ? @query<<"cover" : @book.update_attributes(cover: parsed_cover)
    File.delete(parsed_cover) if File.exists?(parsed_cover)
    parsed_cover.close unless parsed_cover.closed?
    respond_to do |format|
      if !@query.blank?
        format.js {  }
        return
      end
      if @book.save
        format.html { redirect_to @book, notice: 'Book was successfully created.' }
        format.json { render :show, status: :created, location: @book }
      else
        format.html { render :new }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /books/1
  # PATCH/PUT /books/1.json
  def update
    respond_to do |format|
      add_relations_from_select
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

    def cover_image(book)
      cover_types=%w(cover-image cover)
      tmp_dir = "tmp/"
      Dir.mkdir(tmp_dir) unless Dir.exist?(tmp_dir)
      book.resources.each do |resource|
        if resource.id.in?(cover_types)
          Zip::File.open(@book.book_file.current_path) do |zip_file|
            found_cover = zip_file.glob(resource.href.to_s).first
            if !found_cover.blank?
              tmp_filepath = tmp_dir+File.basename(found_cover.name)
              found_cover.extract(tmp_filepath) if !tmp_filepath.blank?
              return tmp_filepath
            end
          end
        end
      end
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

    # ADD publishers and authors to book
    def add_relations_from_select
      @book.authors<<Author.find(book_params[:author_ids].select{|a| !a.blank?})
      @book.publishers<<Publisher.find(book_params[:publisher_ids].select{|a| !a.blank?})
      params[:book].delete :author_ids
      params[:book].delete :publisher_ids
    end
end
