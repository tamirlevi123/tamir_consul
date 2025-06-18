class CreateNodeVotes < ActiveRecord::Migration[7.1]
  def change
    unless table_exists?(:node_votes)
      create_table :node_votes do |t|
        t.references :user, foreign_key: true
        t.references :decision_node, foreign_key: true
        t.string :vote_type

        t.timestamps
      end
    end
  end
end
