class CreateNotices < ActiveRecord::Migration[6.0]
  def change
    create_table :notices do |t|
      t.references(:noticeable, polymorphic: true)
      t.references(:send_user, foreign_key: { to_table: :users })
      t.references(:receive_user, foreign_key: { to_table: :users })
      t.timestamps
    end
  end
end
