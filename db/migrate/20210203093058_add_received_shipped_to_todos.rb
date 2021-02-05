class AddReceivedShippedToTodos < ActiveRecord::Migration[6.0]
  def change
    remove_column(:products, :shipped)
    remove_column(:products, :received)
    add_column(:todos, :shipped, :boolean, default: false)
    add_column(:todos, :received, :boolean, default: false)
  end
end
