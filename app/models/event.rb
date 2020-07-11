class Event < ApplicationRecord
  belongs_to :user

  validates :value, presence: true, numericality: { only_integer: true}
  validates :date, presence:true
  validates :genre, presence:true
  validates :account, presence:true
end
