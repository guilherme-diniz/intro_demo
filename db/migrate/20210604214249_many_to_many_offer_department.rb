class ManyToManyOfferDepartment < ActiveRecord::Migration[6.1]
  def change
    create_table :departments_offers, id: false do |t|
      t.belongs_to :offer
      t.belongs_to :department
    end
  end
end
