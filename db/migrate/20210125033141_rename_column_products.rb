class RenameColumnProducts < ActiveRecord::Migration[6.0]
  def change
    rename_column(:products, :trading, :traded)
  end
end
