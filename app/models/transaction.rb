class Transaction < ApplicationRecord
    validates :payer, :points, :date, presence: true
    validates :points, numericality: { only_integer: true }
end
