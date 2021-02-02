class CreateTodos < ActiveRecord::Migration[6.0]
  def change
    create_table :todos do |t|
      t.references(:purchaced_product, foreign_key: true)
      t.timestamps
    end
  end
end
