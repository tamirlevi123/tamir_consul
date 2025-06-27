class AddChildTypeToDecisionNodes < ActiveRecord::Migration[7.1]
  def change
    add_column :decision_nodes, :child_type, :integer
  end
end
