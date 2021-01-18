class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string(:email)
      t.string(:password_digest)
      t.string(:account_name)
      t.string(:family_name)
      t.string(:first_name)
      t.integer(:postal_code)
      t.references(:prefecture, foreign_key: true)
      t.string(:address)
      t.boolean(:activated)
      t.string(:activation_digest)
      t.string(:reset_digest)
      t.string(:session_digest)
      t.timestamps
    end
    add_index(:users, :email, { unique: true })
  end
end