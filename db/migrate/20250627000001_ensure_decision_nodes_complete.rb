class EnsureDecisionNodesComplete < ActiveRecord::Migration[7.1]
  def change
    # Add child_type column if it doesn't exist
    add_column :decision_nodes, :child_type, :integer unless column_exists?(:decision_nodes, :child_type)
    
    # Add user_id column if it doesn't exist
    add_column :decision_nodes, :user_id, :bigint unless column_exists?(:decision_nodes, :user_id)
    
    # Add position column if it doesn't exist
    add_column :decision_nodes, :position, :integer unless column_exists?(:decision_nodes, :position)
    
    # Add url column if it doesn't exist
    add_column :decision_nodes, :url, :string unless column_exists?(:decision_nodes, :url)
    
    # Add url_confirmed column if it doesn't exist
    add_column :decision_nodes, :url_confirmed, :boolean, default: false, null: false unless column_exists?(:decision_nodes, :url_confirmed)
    
    # Add indexes if they don't exist
    add_index :decision_nodes, :user_id unless index_exists?(:decision_nodes, :user_id)
    add_index :decision_nodes, :decision_tree_id unless index_exists?(:decision_nodes, :decision_tree_id)
    add_index :decision_nodes, :parent_id unless index_exists?(:decision_nodes, :parent_id)
  end
end 