class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable
 has_many :accounts, dependent: :destroy
 has_many :account_exchanges, dependent: :destroy
 has_many :genres, dependent: :destroy
 has_many :events, dependent: :destroy
end
