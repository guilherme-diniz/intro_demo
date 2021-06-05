class Offer < ApplicationRecord
  has_and_belongs_to_many :departments
  scope :matches, ->(company) { where(company: company).includes(:departments) }
  scope :not_matched, ->(company) { where.not(company: company) }

  def serialize(label = :offer)
    { id: id, price: price, company: company, label: label }
  end
end
