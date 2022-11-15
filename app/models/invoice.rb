class Invoice < ApplicationRecord
  belongs_to :customer
  has_many :transactions
  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :merchants, through: :items
  validates_presence_of :status, :customer_id

  enum status: { 'in progress' => 0, completed: 1, cancelled: 2 }

  def total_revenue
    invoice_items.sum('unit_price * quantity')
  end

  def total_revenue_to_dollars
    (self.total_revenue.to_f/100.00).round(2)
  end

  def self.incomplete_invoices
    joins(:invoice_items)
      .where('invoice_items.status=0 OR invoice_items.status=1')
      .order(:created_at)
  end

  def invoice_discount_dollars
    # invoice_items.sum(&:invoice_item_revenue).round(2)
    invoice_items.joins(:bulk_discounts)
    .where('invoice_items.quantity >= bulk_discounts.quantity_threshold')
    .sum('invoice_items.quantity * (invoice_items.unit_price * .01) * (bulk_discounts.percentage * .01)')
    .to_f
    .round(2)
  end

  def discounted_total_revenue
    if BulkDiscount.exists?
    (total_revenue_to_dollars - invoice_discount_dollars).round(2)
    else
      return "N/A"
    end
  end
end
