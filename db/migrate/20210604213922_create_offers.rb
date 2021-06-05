class CreateOffers < ActiveRecord::Migration[6.1]
  def change
    create_table :offers do |t|
      t.float :price
      t.string :company

      t.timestamps
    end
  end
end
