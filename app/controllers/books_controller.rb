class BooksController < ApplicationController
  before_action :is_matching_login_user, only: [:edit, :update]

  def show
    @book = Book.find(params[:id])
    @post_book = Book.new
    @book_comment = BookComment.new
    @book_detail = Book.find(params[:id])
    unless ViewCount.find_by(user_id: current_user.id, book_id: @book_detail.id)
      current_user.view_counts.create(book_id: @book_detail.id)
    end
  end

  def index
    # 課題7aで不要に
    # @books = Book.all
    
    # 現在の日時を取得し、その日の終了時刻を代入します。
    to  = Time.current.at_end_of_day
    # 現在日時から6日前の日時を取得し、その日の開始時刻を代入します。
    # これにより直近の1週間の期間を取得します。
    from  = (to - 6.day).at_beginning_of_day
    # 全てのBookを取得します。
    @books = Book.all.sort {|a,b| 
      # それぞれの本（aとb）に対して、直近の1週間でのいいねの数を計算します。
      # そして、そのいいねの数を使って本をソートします。
      # Rubyの<=>演算子（宇宙船演算子）は、
      # 左の値が大きければ1、等しければ0、小さければ-1を返します。
      # つまり、bのいいねの数が多ければ1、等しければ0、少なければ-1が返されます。
      # Arrayのsortメソッドは、ブロックが1を返すときに要素を入れ替えます。
      # したがって、このコードはいいねの数が多い本を前にするように本をソートします。
      b.favorites.where(created_at: from...to).size <=> 
      a.favorites.where(created_at: from...to).size
    }
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
    params.require(:book).permit(:title, :body, :star)
  end
  
  def is_matching_login_user
    book = Book.find(params[:id])
    unless book.user.id == current_user.id
      redirect_to books_path
    end
  end
  
end
