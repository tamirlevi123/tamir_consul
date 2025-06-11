class DecisionNode < ApplicationRecord
  belongs_to :decision_tree
  belongs_to :user
  has_many :node_votes, dependent: :destroy
  has_many :child_nodes, class_name: 'DecisionNode', foreign_key: 'parent_id'
  belongs_to :parent, class_name: 'DecisionNode', optional: true
  
  validates :content, presence: true
  validates :position, presence: true
end
