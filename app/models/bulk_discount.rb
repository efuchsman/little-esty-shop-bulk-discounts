class BulkDiscount < ApplicationRecord
  belongs_to :merchant
  has_many :items, through: :merchant
  has_many :invoice_items, through: :items
  validates_presence_of :name, :percentage, :quantity_threshold
  validates_numericality_of :percentage, greater_than: 0
  validates_numericality_of :percentage, less_than: 100
  validates_numericality_of :quantity_threshold, greater_than: 0
end
