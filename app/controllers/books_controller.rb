class BooksController < ApplicationController
  before_action :is_matching_login_user, only: [:edit, :update]

  def show
    @book = Book.find(params[:id])
    @post_book = Book.new
    @book_comment = BookComment.new
  end

  def index
    # 課題7aで不要に
    # @books = Book.all
    
    # 1週間以内のFavoritesを取得するための日付を算出
    one_week_ago = Time.current - 1.week

    # 一週間内にいいねがついた本をいいねの数順に取得
    @books_with_recent_favorites = Book.left_joins(:favorites)
      .where(favorites: { created_at: one_week_ago..Time.current })
      .group('books.id')
      .order('COUNT(favorites.id) DESC')

    # それ以外の本（一週間内にいいねがついていない本）を投稿日順に取得
    @books_without_recent_favorites = Book.left_joins(:favorites)
      .where.not(id: @books_with_recent_favorites.pluck(:id))
      .order(created_at: :desc)

    # 上記2つのリストを結合
    @books = @books_with_recent_favorites + @books_without_recent_favorites
    
    @book = Book.new
  end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    if @book.save
      redirect_to book_path(@book), notice: "You have created book successfully."
    else
      @books = Book.all
      render 'index'
    end
  end

  def edit
    @book = Book.find(params[:id])
  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      redirect_to book_path(@book), notice: "You have updated book successfully."
    else
      render "edit"
    end
  end

  def destroy
    book = Book.find(params[:id])
    book.destroy
    redirect_to books_path
  end

  private

  def book_params
    params.require(:book).permit(:title, :body)
  end
  
  def is_matching_login_user
    book = Book.find(params[:id])
    unless book.user.id == current_user.id
      redirect_to books_path
    end
  end
  
end
