class CreateSearchTerms < ActiveRecord::Migration[5.2]
  def change
    create_table :search_terms do |t|
      t.string :term
      t.string :timespan
      t.datetime :last_check
      t.integer :check_frequency

      t.timestamps
    end
  end
end
