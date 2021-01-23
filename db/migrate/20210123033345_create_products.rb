class CreateProducts < ActiveRecord::Migration[6.0]
  def change
    create_table :products do |t|
      t.string(:name)
      t.text(:description)
      t.integer(:price)
      t.boolean(:trading, default: false)
      t.boolean(:solded, default: false)
      t.references(:user, foreign_key: true)
      t.references(:shipping_day, foreign_key: true)
      t.references(:status, foreign_key: true)
      t.references(:category, foreign_key: true)
      t.timestamps
    end
  end
end