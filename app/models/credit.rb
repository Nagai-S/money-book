class Credit < ApplicationRecord
  belongs_to :user
  validates :name, presence: true, uniqueness: { scope: :user }
  validates :account, presence: true
  validates :pay_date, presence: true,
                       numericality: { only_integer: true},
                       numericality: {greater_than_or_equal_to: 1},
                       numericality: {less_than_or_equal_to: 31}
  validates :month_date, presence: true,
                       numericality: { only_integer: true},
                       numericality: {greater_than_or_equal_to: 1},
                       numericality: {less_than_or_equal_to: 31}
end
