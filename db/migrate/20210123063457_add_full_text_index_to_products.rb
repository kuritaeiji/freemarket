class AddFullTextIndexToProducts < ActiveRecord::Migration[6.0]
  def self.up
    execute("create fulltext index `name_description_fulltext_idx` on `products` (`name`, `description`) with parser ngram")
  end

  def self.down
    execute("drop index `name_description_fulltext_idx` on `products`")
  end
end
