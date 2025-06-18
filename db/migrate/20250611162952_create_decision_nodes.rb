class CreateDecisionNodes < ActiveRecord::Migration[7.1]
  def change
    unless table_exists?(:decision_nodes)
      create_table :decision_nodes do |t|
        t.text :content
        t.references :parent, foreign_key: { to_table: :decision_nodes }
        t.references :decision_tree, foreign_key: true

        t.timestamps
      end
    end
  end
end
