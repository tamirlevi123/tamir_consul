class AddHeadlineToDecisionNodes < ActiveRecord::Migration[7.1]
  def change
    add_column :decision_nodes, :headline, :string unless column_exists?(:decision_nodes, :headline)
    
    # Populate headlines for existing nodes
    reversible do |dir|
      dir.up do
        DecisionNode.reset_column_information
        DecisionNode.find_each do |node|
          if node.headline.blank? && node.content.present?
            # Create a headline from the first 100 characters of content
            headline = node.content.strip[0..99]
            # Add ellipsis if content was truncated
            headline += "..." if node.content.length > 100
            node.update_column(:headline, headline)
          end
        end
      end
    end
  end
end
