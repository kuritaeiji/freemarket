class AddFullTextIndexToProducts < ActiveRecord::Migration[6.0]
  def change
    execute("create fulltext index `name_description_fulltext_idx` on `products` (`name`, `description`) with parser ngram")
  end
end
