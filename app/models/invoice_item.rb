class InvoiceItem < ApplicationRecord
  belongs_to :item
  belongs_to :invoice
  has_one :merchant, through: :item
  has_many :bulk_discounts, through: :merchant


  validates_presence_of :quantity, :unit_price, :status, :item_id, :invoice_id

  enum status: { pending: 0, packaged: 1, shipped: 2 }

  def unit_price_to_dollars
    (unit_price.to_f/100.00).round(2)
  end

  def discount?
    bulk_discounts.order(percentage: :desc).where("quantity_threshold <= #{self.quantity}").exists?
  end

  def return_available_discounts
    if !self.discount?
      nil
    else
      bulk_discounts.order(percentage: :desc).where("quantity_threshold <= #{self.quantity}")
    end
  end

  def return_best_discount
    if !self.discount?
      nil
    else
      bulk_discounts.order(percentage: :desc).where("quantity_threshold <= #{self.quantity}").first
    end
  end

  def invoice_item_revenue
    if return_available_discounts.nil?
      (quantity * unit_price_to_dollars).round(2)
    else
      ((quantity * unit_price_to_dollars)*(1 -(return_best_discount.percentage.to_f/100))).round(2)
    end
  end
end
