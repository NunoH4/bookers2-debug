class BookCommentsController < ApplicationController
  
  def create
    book = Book.find(params[:book_id])
    comment = current_user.book_comments.new(book_comment_params)
    comment.book_id = book.id
    comment.save
    
    # 以下はコメント機能を非同期通信にしたため不必要
    # redirect_back(fallback_location: root_path)
  end
  
  def destroy
    BookComment.find(params[:id]).destroy
    
    # 以下はコメント機能を非同期通信にしたため不必要
    # redirect_back(fallback_location: root_path)
  end
  
  private

  def book_comment_params
    params.require(:book_comment).permit(:comment)
  end
  
end
