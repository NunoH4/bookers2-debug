class BookCommentsController < ApplicationController
  
  def create
    @book = Book.find(params[:book_id])
    comment = current_user.book_comments.new(book_comment_params)
    comment.book_id = @book.id
    comment.save
    
    # コメント機能を非同期通信にするため不必要
    # redirect_back(fallback_location: root_path)
  end
  
  def destroy
    @book = Book.find(params[:book_id])
    BookComment.find(params[:id]).destroy
    
    # コメント機能を非同期通信にするため不必要
    # redirect_back(fallback_location: root_path)
  end
  
  private

  def book_comment_params
    params.require(:book_comment).permit(:comment)
  end
  
end
