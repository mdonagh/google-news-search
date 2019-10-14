class CreateSearchResults < ActiveRecord::Migration[5.2]
  def change
    create_table :search_results do |t|
      t.references :search_term, foreign_key: true
      t.integer :total
      t.timestamps
    end
  end
end
