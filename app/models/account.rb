class Account < ApplicationRecord
  belongs_to :user

  default_scope -> {order(value: :desc)}

  validates :name, presence: true
  validates :value, presence: true, numericality: { only_integer: true}
end
