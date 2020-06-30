class AccountExchange < ApplicationRecord
  belongs_to :user

  default_scope -> {order(date: :desc)}

  validates :bname, presence: true
  validates :aname, presence: true
  validates :value, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :date, presence:true
end
