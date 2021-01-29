class CreateMessages < ActiveRecord::Migration[6.0]
  def change
    create_table :messages do |t|
      t.text(:content)
      t.references(:user, foreign_key: true)
      t.references(:messageable, polymorphic: true)
      t.timestamps
    end
  end
end
