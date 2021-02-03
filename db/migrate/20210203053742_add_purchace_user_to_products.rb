class AddPurchaceUserToProducts < ActiveRecord::Migration[6.0]
  def change
    add_reference(:products, :purchace_user, foreign_key: { to_table: :users })
  end
end
