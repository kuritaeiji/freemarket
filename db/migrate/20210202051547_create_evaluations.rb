class CreateEvaluations < ActiveRecord::Migration[6.0]
  def change
    create_table :evaluations do |t|
      t.integer(:score, default: 0)
      t.references(:purchaced_product, foreign_key: true)
      t.timestamps
    end
  end
end
