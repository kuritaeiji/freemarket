class CreateShippingDays < ActiveRecord::Migration[6.0]
  def change
    create_table :shipping_days do |t|
      t.string(:days)
      t.timestamps
    end
  end
end