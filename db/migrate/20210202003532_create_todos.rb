class CreateTodos < ActiveRecord::Migration[6.0]
  def change
    create_table :todos do |t|
      t.references(:product, foreign_key: true)
      t.timestamps
    end
  end
end
