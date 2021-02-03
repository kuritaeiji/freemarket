class CreateTodos < ActiveRecord::Migration[6.0]
  def change
    create_table :todos do |t|
      t.boolean(:shipped, default: false)
      t.boolean(:received, default: false)
      t.references(:product, foreign_key: true)
      t.timestamps
    end
  end
end
