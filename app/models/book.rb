class Book < ApplicationRecord
  belongs_to :user
  has_many :book_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :view_counts, dependent: :destroy
  
  validates :title, presence:true
  validates :body, presence:true, length:{maximum:200}
  
  # 直近1週間のいいねを取得するための関連付けを定義します。
  # Time.current.at_end_of_day - 6.day).at_beginning_of_day から Time.current.at_end_of_day の間に作成されたいいねを取得します。
  # class_nameオプションを使って、関連付けられるモデルのクラス名を指定しています。この場合、Favoriteモデルが対象となります。
  has_many :week_favorites, -> { where(created_at: ((Time.current.at_end_of_day - 6.day).at_beginning_of_day)..(Time.current.at_end_of_day)) }, class_name: 'Favorite'
  
  scope :latest, -> {order(created_at: :desc)}
  scope :old, -> {order(created_at: :asc)}
  scope :star_count, -> {order(star: :desc)}
  
  
  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end
  
  def self.search_for(content, method)
    if method == 'perfect'
      Book.where(title: content)
    elsif method == 'forward'
      Book.where('title LIKE ?', content+'%')
    elsif method == 'backward'
      Book.where('title LIKE ?', '%'+content)
    else
      Book.where('title LIKE ?', '%'+content+'%')
    end
  end

  
end