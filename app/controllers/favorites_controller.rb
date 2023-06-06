class FavoritesController < ApplicationController
  before_action :authenticate_user!

  def create
    @book = Book.find(params[:book_id])
    favorite = current_user.favorites.new(book_id: @book.id)
    favorite.save

    # 以下はいいね機能を非同期通信にしたため不必要
    # redirect_back(fallback_location: root_path)
  end

  def destroy
    @book = Book.find(params[:book_id])
    favorite = current_user.favorites.find_by(book_id: @book.id)
    favorite.destroy

    # 以下はいいね機能を非同期通信にしたため不必要
    # redirect_back(fallback_location: root_path)
  end

end