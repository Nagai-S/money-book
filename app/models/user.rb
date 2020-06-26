class User < ApplicationRecord
  attr_accessor :remember_token, :activation_token, :reset_token
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  has_secure_password

  # バリデーション
  validates :password, presence: true, length: {minimum: 6, message: "６文字以上にしてください"}
  validates :email, presence: true, format: {with: VALID_EMAIL_REGEX},
                    uniqueness: {case_sensitive: false}

  # ランダムなトークンを返す
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  # 渡された文字列のハッシュ値を返す
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # 永続セッションのためにユーザーをデータベースに記憶する
  def remember
    self.remember_token=User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # 渡されたトークンがダイジェストと一致したらtrueを返す
  def authemticated?(remember_token)
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end
end
