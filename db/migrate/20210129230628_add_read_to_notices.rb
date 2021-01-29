class AddReadToNotices < ActiveRecord::Migration[6.0]
  def change
    add_column(:notices, :read, :boolean, default: false)
  end
end
