class CreatePurchacedProducts < ActiveRecord::Migration[6.0]
  def change
    create_table :purchaced_products do |t|
      t.boolean(:shipped, default: false)
      t.boolean(:received, default: false)
      t.references(:product, foreign_key: true)
      t.references(:purchace_user, foreign_key: { to_table: :users })
      t.timestamps
    end
  end
end
