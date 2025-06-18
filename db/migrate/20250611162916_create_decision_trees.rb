class CreateDecisionTrees < ActiveRecord::Migration[7.1]
  def change
    unless table_exists?(:decision_trees)
      create_table :decision_trees do |t|
        t.string :title
        t.text :description
        t.references :user, foreign_key: true

        t.timestamps
      end
    end
  end
end
