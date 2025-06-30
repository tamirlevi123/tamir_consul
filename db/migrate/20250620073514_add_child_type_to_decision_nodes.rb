class AddChildTypeToDecisionNodes < ActiveRecord::Migration[7.1]
  def change
    add_column :decision_nodes, :child_type, :integer unless column_exists?(:decision_nodes, :child_type)
  end
end
